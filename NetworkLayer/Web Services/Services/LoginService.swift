//
//  LoginWebService.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 1/30/22.
//

import Foundation
import Moya

typealias LoginCompletion = (Result<LoginResult, CustomError>) -> Void

protocol LoginServiceProtocol: CancellableServiceProtocol {
    func login(username: String, password: String, completion: @escaping LoginCompletion)
    func logout(completion: @escaping EmptyCompletion)
}

protocol HasLoginService {
    var loginService: LoginServiceProtocol { get }
}

final class LoginService: BaseService, LoginServiceProtocol {
    private let provider: MoyaProvider<LoginApi>

    init(provider: MoyaProvider<LoginApi>) {
        self.provider = provider
    }

    func login(username: String, password: String, completion: @escaping LoginCompletion) {
        self.runningRequest = provider.request(.login(username: username,
                                                      password: password)) { result in
            self.processResult(result, completion: completion)
        }
    }

    func logout(completion: @escaping EmptyCompletion) {
        self.runningRequest = provider.request(.logout) { result in
            self.processEmptyResult(result, completion: completion)
        }
    }
}
