//
//  Result+Mapping.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/13/22.
//

import Foundation
import Moya

extension Result where Failure == CustomError {

    /// Map one Result to another Result, preserving failure but changing Success type
    /// - Parameter mapping: closure for mapping one Success result to another
    /// - Returns: Result with either Failure or Success
    func mapSuccess<T>(_ mapping: (Success) -> Result<T, CustomError>) -> Result<T, CustomError> {
        switch self {
        case .success(let success):
            return mapping(success)
        case .failure(let error):
            return .failure(error)
        }
    }

    /// Here we map any success Result to empty Success result, failure is mapped to failure
    /// - Returns: empty success result
    func mapSuccessEmpty() -> Result<Void, CustomError> {
        switch self {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
