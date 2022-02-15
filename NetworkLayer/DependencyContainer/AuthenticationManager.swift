//
//  AuthenticationManager.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/13/22.
//

import Foundation

protocol AuthenticationManagerProtocol {
    var token: String? { get set }
    var isAuthenticated: Bool { get }
}

protocol HasAuthenticationManager {
    var authenticationManager: AuthenticationManagerProtocol { get }
}

extension AuthenticationManagerProtocol {
    var isAuthenticated: Bool {
        return token != nil
    }
}

struct AuthenticationManager: AuthenticationManagerProtocol {
    var token: String?
}
