//
//  Result+FilterErrors.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/13/22.
//

import Foundation
import Moya
import Alamofire

extension Result where Success == Moya.Response, Failure == MoyaError {

    /// In this function all server errors are processed, we are converting Result to Result
    /// - Returns: Swift Result with either Failure or Success
    func filterServerErrors() -> Result<Moya.Response, CustomError> {
        switch self {
        case .success(let response):
            return .success(response)
        case .failure(let error):
            switch error {
            case .underlying(let underlyingError, _):
                if let internalError = underlyingError as? CustomError {
                    return .failure(internalError)
                } else if let afError = underlyingError as? AFError {
                    if case .explicitlyCancelled = afError {
                        return .failure(.requestCancelled)
                    } else if case .sessionTaskFailed(let error) = afError,
                              let urlError = error as? URLError,
                              urlError.checkNoInternetConnection {
                        return .failure(.noInternetConnection)
                    } else {
                        return .failure(.underlying(underlyingError, nil))
                    }
                } else {
                    return .failure(.underlying(underlyingError, nil))
                }
            default:
                return .failure(.unknownNetworkError)
            }
        }
    }
}

extension URLError {

    var checkNoInternetConnection: Bool {
        let code = URLError.Code(rawValue: errorCode)
        return (code == .notConnectedToInternet || code == .cannotConnectToHost)
    }
}
