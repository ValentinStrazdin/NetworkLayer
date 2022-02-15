//
//  JSONDecoder+Custom.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/14/22.
//

import Foundation

extension JSONDecoder {

    static var custom: JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter(customDateFormat: .apiDate)
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
}
