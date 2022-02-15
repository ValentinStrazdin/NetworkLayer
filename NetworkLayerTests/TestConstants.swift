//
//  TestConstants.swift
//  NetworkLayerTests
//
//  Created by Valentin Strazdin on 2/13/22.
//

import Foundation
@testable import NetworkLayer

struct TestConstants {
    static let username = "username"
    static let password = "password"

    static let userId = 1001

    static var userModel: UserModel {
        var dateComponents = DateComponents()
        dateComponents.year = 1845
        dateComponents.month = 7
        dateComponents.day = 1
        let dateOfBirth = Calendar.current.date(from: dateComponents)!
        return UserModel(firstName: "Scarlett",
                         lastName: "O'Hara",
                         dateOfBirth: dateOfBirth)
    }
}
