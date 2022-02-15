//
//  JSONEncoder+Custom.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/14/22.
//

import Foundation

extension JSONEncoder {

    static var custom: JSONEncoder {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter(customDateFormat: .apiDate)
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }
}
