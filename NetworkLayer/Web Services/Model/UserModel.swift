//
//  UserModel.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 1/30/22.
//

import Foundation

struct UserModel: Codable {
    var id: Int?
    var firstName: String?
    var lastName: String?
    var dateOfBirth: Date?

    init(firstName: String?, lastName: String?, dateOfBirth: Date? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
    }

    var description: String {
        var descriptions: [String] = []
        if let id = id {
            descriptions.append("id: \(id)")
        }
        if let firstName = firstName {
            descriptions.append("firstName: \(firstName)")
        }
        if let lastName = lastName {
            descriptions.append("lastName: \(lastName)")
        }
        if let dateOfBirth = dateOfBirth {
            descriptions.append("dateOfBirth: \(dateOfBirth.displayString)")
        }
        return "UserModel(\(descriptions.joined(separator: ", ")))"
    }
}
