//
//  JSONHelper.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/12/22.
//

import Foundation

public class JSONHelper {

    /// This function can be used in Unit Tests for loading JSON files as Data
    public static func loadFromFile(_ fileName: String) -> Data {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return Data()
        }
        return data
    }
}
