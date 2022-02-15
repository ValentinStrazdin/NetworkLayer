//
//  UserWebService.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/12/22.
//

import Foundation
import Moya

typealias UsersCompletion = (Result<[UserModel], CustomError>) -> Void

protocol UserServiceProtocol: CancellableServiceProtocol {
    func createUser(_ user: UserModel, completion: @escaping EmptyCompletion)
    func getUsers(completion: @escaping UsersCompletion)
    func updateUser(id: Int, user: UserModel, completion: @escaping EmptyCompletion)
    func deleteUser(id: Int, completion: @escaping EmptyCompletion)
}

protocol HasUserService {
    var userService: UserServiceProtocol { get }
}

final class UserService: BaseService, UserServiceProtocol {
    private let provider: MoyaProvider<UserApi>

    init(provider: MoyaProvider<UserApi>) {
        self.provider = provider
    }

    func createUser(_ user: UserModel, completion: @escaping EmptyCompletion) {
        self.runningRequest = provider.request(.createUser(user)) { result in
            self.processEmptyResult(result, completion: completion)
        }
    }

    func getUsers(completion: @escaping UsersCompletion) {
        self.runningRequest = provider.request(.getUsers) { result in
            self.processResult(result, completion: completion)
        }
    }

    func updateUser(id: Int, user: UserModel, completion: @escaping EmptyCompletion) {
        self.runningRequest = provider.request(.updateUser(id: id,
                                                           user: user)) { result in
            self.processEmptyResult(result, completion: completion)
        }
    }

    func deleteUser(id: Int, completion: @escaping EmptyCompletion) {
        self.runningRequest = provider.request(.deleteUser(id: id)) { result in
            self.processEmptyResult(result, completion: completion)
        }
    }
}
