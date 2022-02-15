//
//  LoginApi.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 1/30/22.
//

import Foundation
import Moya

enum LoginApi {
    case login(username: String, password: String)
    case logout
}

extension LoginApi: TargetType {
    var baseURL: URL {
        AppConfig.serverUrl
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .logout:
            return "/logout"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        switch self {
            case .login:
                return JSONHelper.loadFromFile("LoginResponse")
        default:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .login(username: let username, password: let password):
            return .requestJSONEncodable(["username": username,
                                          "password": password])
        case .logout:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}

extension LoginApi: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .login:
            return .none
        case .logout:
            return .bearer
        }
    }
}
