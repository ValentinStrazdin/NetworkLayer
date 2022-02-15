//
//  UserApi.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/12/22.
//

import Foundation
import Moya

enum UserApi {
    case createUser(_ user: UserModel)
    case getUsers
    case updateUser(id: Int, user: UserModel)
    case deleteUser(id: Int)
}

extension UserApi: TargetType {
    var baseURL: URL {
        AppConfig.serverUrl
    }

    var path: String {
        switch self {
        case .getUsers, .createUser(_):
            return "/users"
        case .updateUser(let id, _), .deleteUser(let id):
            return "/users/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createUser(_):
            return .post
        case .getUsers:
            return .get
        case .updateUser(_, _):
            return .put
        case .deleteUser(_):
            return .delete
        }
    }

    var sampleData: Data {
        switch self {
            case .getUsers:
                return JSONHelper.loadFromFile("UsersResponse")
        default:
            return Data()
        }
    }

    var task: Task {
        switch self {
        case .getUsers, .deleteUser(_):
            return .requestPlain
        case .createUser(let user), .updateUser(_, let user):
            return .requestCustomJSONEncodable(user, encoder: .custom)
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }

}

extension UserApi: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        return .bearer
    }
}
