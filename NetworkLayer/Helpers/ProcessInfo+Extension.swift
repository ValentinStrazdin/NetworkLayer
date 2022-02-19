//
//  UnitTestHelper.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/19/22.
//

import Foundation

extension ProcessInfo {

    static var isRunningTests: Bool {
        return (processInfo.environment["XCTestConfigurationFilePath"] != nil)
    }
}
