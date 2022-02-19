//
//  URLSessionConfiguration+Default.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/15/22.
//

import Foundation
import Alamofire

extension URLSessionConfiguration {

    /// Here we configure Default Request timeout interval
    static var defaultConfig: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 90
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        return configuration
    }
}
