//
//  CustomError.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/13/22.
//

import Foundation
import Moya

public enum CustomError: Swift.Error {
    case requestCancelled
    case noInternetConnection
    case unknownNetworkError
    case emptyData
    case underlying(Swift.Error, Moya.Response?)

    var description: String {
        switch self {
        case .requestCancelled:
            return "Request Cancelled"
        case .noInternetConnection:
            return "No Internet Connection"
        case .unknownNetworkError:
            return "Unknown Network Error"
        case .emptyData:
            return "Empty Data"
        case .underlying(let error, _):
            return "Underlying error - \(error.localizedDescription)"
        }
    }
}
