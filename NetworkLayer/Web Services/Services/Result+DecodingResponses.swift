//
//  Result+Decoding.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/13/22.
//

import Foundation
import Moya

extension Result where Success == Moya.Response, Failure == CustomError {

    /// Decoding Object from Moya.Response, returns either Success with object or Failure with specific error
    /// - Parameter logger: Logger that we use for logging decoding errors
    /// - Returns: result with either Success or Failure
    func decodeObject<T: Decodable>(using decoder: JSONDecoder = JSONDecoder()) -> Result<T, CustomError> {
        return self.mapSuccess { response in
            do {
                let object = try response.map(T.self, using: decoder)
                return .success(object)
            } catch let moyaError as MoyaError {
                if case .objectMapping(let error, _) = moyaError,
                   let decodingError = error as? DecodingError {
                    print("Error Decoding '\(String(describing: T.self))' from Server Response:\n   \(decodingError.description)")
                } else {
                    if case .underlying(let nsError as NSError, _) = moyaError {
                        print("Status code: \(nsError.code)")
                    } else if let description = moyaError.errorDescription {
                        print(description)
                    }
                }
                return .failure(.underlying(moyaError, response))
            } catch {
                print("error: \(String(describing: error))")
                return .failure(.unknownNetworkError)
            }
        }
    }
}

extension Result where Failure == CustomError {

    var isRequestCancelled: Bool {
        switch self {
        case .failure(let error):
            switch error {
            case .requestCancelled:
                return true
            default:
                return false
            }
        default:
            return false
        }
    }
}
