//
//  HasRunningRequests.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/23/22.
//

import Foundation
import Moya

public protocol HasRunningRequests: AnyObject {
    var runningRequests: [Cancellable?] { get set }
    func cancelRequests()
}

extension HasRunningRequests {

    public func cancelRequests() {
        for request in runningRequests {
            request?.cancel()
        }
        runningRequests.removeAll()
    }
}
