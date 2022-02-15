//
//  NetworkLayerIntegrationTests.swift
//  NetworkLayerTests
//
//  Created by Valentin Strazdin on 2/13/22.
//

import XCTest
import Moya

@testable import NetworkLayer

class NetworkLayerIntegrationTests: XCTestCase {
    private lazy var authenticationManager: AuthenticationManagerProtocol = {
        AuthenticationManager()
    }()

    private let sessionDelegate = CustomSessionDelegate()
    // This is the URLSession where we setup our custom configuration and delegate for SSL Pinning
    private lazy var session: Session = {
        Session(configuration: .defaultConfig, delegate: sessionDelegate)
    }()
    
    // MARK: - Moya Providers
    private lazy var loginProvider: MoyaProvider<LoginApi> = {
        MoyaProvider<LoginApi>(session: session, plugins: plugins)
    }()
    private lazy var userProvider: MoyaProvider<UserApi> = {
        MoyaProvider<UserApi>(session: session, plugins: plugins)
    }()
    
    // MARK: - Moya Plugins
    private let networkLoggerConfiguration = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
    private var plugins: [PluginType] {
        [accessTokenPlugin, NetworkLoggerPlugin(configuration: networkLoggerConfiguration)]
    }

    private lazy var accessTokenPlugin: AccessTokenPlugin = {
        AccessTokenPlugin(tokenClosure: getAuthorizationToken)
    }()

    // MARK: - Services
    private lazy var loginService: LoginServiceProtocol = {
        LoginService(provider: loginProvider)
    }()

    private lazy var userService: UserServiceProtocol = {
        UserService(provider: userProvider)
    }()

    func testLogin() {
        let loginExpectation = expectation(description: "login")
        login(expectation: loginExpectation) {
            loginExpectation.fulfill()
        }
        waitForExpectations(timeout: 90, handler: nil)
    }

    func testGetUsers() {
        let getUsersExpectation = expectation(description: "getUsers")
        login(expectation: getUsersExpectation) {
            self.userService.getUsers { result in
                switch result {
                case .success(let users):
                    print("Users:\n \(users.map({ $0.description }).joined(separator: "\n"))")
                case .failure(let error):
                    XCTFail(error.description)
                }
                getUsersExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 90, handler: nil)
    }

    func testCreateUser() {
        let createUserExpectation = expectation(description: "createUser")
        login(expectation: createUserExpectation) {
            self.userService.createUser(TestConstants.userModel) { result in
                switch result {
                case .success:
                    print("User successfully created")
                case .failure(let error):
                    XCTFail(error.description)
                }
                createUserExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 90, handler: nil)
    }

    func testUpdateUser() {
        let updateUserExpectation = expectation(description: "updateUser")
        login(expectation: updateUserExpectation) {
            self.userService.updateUser(id: TestConstants.userId,
                                        user: TestConstants.userModel) { result in
                switch result {
                case .success:
                    print("User successfully updated")
                case .failure(let error):
                    XCTFail(error.description)
                }
                updateUserExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 90, handler: nil)
    }

    func testDeleteUser() {
        let deleteUserExpectation = expectation(description: "deleteUser")
        login(expectation: deleteUserExpectation) {
            self.userService.deleteUser(id: TestConstants.userId) { result in
                switch result {
                case .success:
                    print("User successfully deleted")
                case .failure(let error):
                    XCTFail(error.description)
                }
                deleteUserExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 90, handler: nil)
    }

    private func login(expectation: XCTestExpectation,
                       completion: @escaping VoidBlock) {
        login(username: TestConstants.username, password: TestConstants.password) { result in
            switch result {
            case .success:
                // In case of success we go to completion
                completion()
            case .failure(let error):
                XCTFail("Error login: \(error.description)")
                expectation.fulfill()
            }
        }
    }

    private func login(username: String, password: String, completion: @escaping EmptyCompletion) {
        loginService.login(username: username, password: password) { result in
            switch result {
            case .success(let loginResult):
                self.authenticationManager.token = loginResult.token
                print("Auth Token - \"\(loginResult.token)\"")
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getAuthorizationToken(authorizationType: AuthorizationType) -> String {
        return authenticationManager.token ?? ""
    }
}

