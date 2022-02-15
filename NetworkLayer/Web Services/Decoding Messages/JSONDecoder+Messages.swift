//
//  JSONDecoder+Messages.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/12/22.
//

import Foundation

extension JSONDecoder {

    /// Here we try to Decode object from JSON and return in errorBlock Decoding error if it fails
    public func decode<T>(_ type: T.Type, from data: Data, errorBlock: ErrorMessageCompletion?) -> T? where T: Decodable {
        do {
            let object = try self.decode(T.self, from: data)
            return object
        } catch let decodingError as DecodingError {
            errorBlock?("Error Decoding '\(String(describing: type))' from JSON:\n   \(decodingError.description)")
            return nil
        } catch {
            errorBlock?("error: \(String(describing: error))")
            return nil
        }
    }

    /// Here we try to Decode object from JSON string and return in errorBlock Decoding error if it fails
    public func decode<T>(_ type: T.Type, from string: String?, errorBlock: ErrorMessageCompletion?) -> T? where T: Decodable {
        guard let data = string?.data(using: .utf8) else {
            errorBlock?("Error Decoding from empty string")
            return nil
        }
        return self.decode(type, from: data, errorBlock: errorBlock)
    }
}
