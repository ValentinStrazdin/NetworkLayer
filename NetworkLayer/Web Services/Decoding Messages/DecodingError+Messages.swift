//
//  DecodingError+Messages.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/12/22.
//

import Foundation

public typealias ErrorMessageCompletion = (String) -> Void

extension DecodingError {

    /// Debug information that will be printed in Output
    var description: String {
        switch self {
        case .dataCorrupted(let context):
            return context.debugDescription
        case .keyNotFound(let key, let context):
            return ["Key '\(key.stringValue)' not found.",
                    "   CodingPath: \(context.codingPath.description)"].joined(separator: "\n")
        case .valueNotFound(let value, let context):
            return ["Value '\(value)' not found.",
                    "   CodingPath: \(context.codingPath.description)"].joined(separator: "\n")
        case .typeMismatch(let type, let context):
            return ["Type '\(type)' mismatch.",
                    "   CodingPath: \(context.codingPath.description)"].joined(separator: "\n")
        default:
            return self.localizedDescription
        }
    }
}

extension Array where Element == CodingKey {

    /// Here is description of Coding Path that will be printed in Output
    var description: String {
        self.map({ $0.stringValue }).joined(separator: "\\")
    }
}
