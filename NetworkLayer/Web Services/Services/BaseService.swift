//
//  BaseService.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/13/22.
//

import Foundation
import Moya

public protocol CancellableServiceProtocol: AnyObject {
    func cancelRequest()
}

typealias VoidBlock = (() -> Void)
public typealias EmptyCompletion = (Result<Void, CustomError>) -> Void

public class BaseService: CancellableServiceProtocol {
    public var runningRequest: Cancellable?

    public func cancelRequest() {
        self.runningRequest?.cancel()
    }

    public func processEmptyResult(_ result: Result<Moya.Response, MoyaError>,
                                   completion: EmptyCompletion) {
        let filteredResult = result.filterServerErrors()
        // If request was cancelled by user we should not run completion block at the end
        guard !filteredResult.isRequestCancelled else { return }
        completion(filteredResult.mapSuccessEmpty())
    }

    public func processResult<T: Decodable>(_ result: Result<Moya.Response, MoyaError>,
                                            completion: (Result<T, CustomError>) -> Void) {
        let filteredResult = result.filterServerErrors()
        let customResult: Result<T, CustomError> = filteredResult.decodeObject(using: .custom)
        // If request was cancelled by user we should not run completion block at the end
        guard !customResult.isRequestCancelled else { return }
        completion(customResult)
    }
}
