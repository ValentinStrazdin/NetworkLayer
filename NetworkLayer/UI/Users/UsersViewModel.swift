//
//  UsersViewModel.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/13/22.
//

import Foundation

class UsersViewModel: HasUserService {
    var userService: UserServiceProtocol
    var users: [UserModel] = []

    init(dependencyContainer: HasUserService = DependencyContainer.shared) {
        self.userService = dependencyContainer.userService
    }

    func getUsers(completion: @escaping EmptyCompletion) {
        userService.getUsers { result in
            switch result {
            case .success(let users):
                self.users = users
                completion(.success(()))
            case .failure(let error):
                self.users = []
                completion(.failure(error))
            }
        }
    }

    func cancelRequests() {
        userService.cancelRequest()
    }
}
