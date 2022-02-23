//
//  UsersViewModel.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/13/22.
//

import Foundation
import Moya

class UsersViewModel: HasUserService, HasRunningRequests {
    var userService: UserServiceProtocol
    var runningRequests: [Cancellable?] = []

    var users: [UserModel] = []

    init(dependencyContainer: HasUserService = DependencyContainer.shared) {
        self.userService = dependencyContainer.userService
    }

    func getUsers(completion: @escaping EmptyCompletion) {
        let request = userService.getUsers { result in
            switch result {
            case .success(let users):
                self.users = users
                completion(.success(()))
            case .failure(let error):
                self.users = []
                completion(.failure(error))
            }
        }
        runningRequests.append(request)
    }
}
