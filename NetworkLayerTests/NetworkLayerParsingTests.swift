//
//  NetworkLayerTests.swift
//  NetworkLayerTests
//
//  Created by Valentin Strazdin on 1/30/22.
//

import XCTest
import Moya

@testable import NetworkLayer

class NetworkLayerParsingTests: XCTestCase {
    // MARK: - Moya Providers
    private lazy var loginProvider: MoyaProvider<LoginApi> = {
        MoyaProvider<LoginApi>(stubClosure: getStubClosure, plugins: plugins)
    }()
    private lazy var userProvider: MoyaProvider<UserApi> = {
        MoyaProvider<UserApi>(stubClosure: getStubClosure, plugins: plugins)
    }()

    // MARK: - Moya Plugins
    private let networkLoggerConfiguration = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
    private var plugins: [PluginType] {
        [NetworkLoggerPlugin(configuration: networkLoggerConfiguration)]
    }

    // MARK: - Services
    private lazy var loginService: LoginServiceProtocol = {
        LoginService(provider: loginProvider)
    }()

    private lazy var userService: UserServiceProtocol = {
        UserService(provider: userProvider)
    }()

    func testParsingLogin() {
        let loginExpectation = expectation(description: "login")
        loginService.login(username: "", password: "") { result in
            switch result {
            case .success(let loginResult):
                print("Auth Token - \"\(loginResult.token)\"")
            case .failure(let error):
                XCTFail("Error Parsing Login Response: \(error.description)")
            }
            loginExpectation.fulfill()
        }
        waitForExpectations(timeout: 90, handler: nil)
    }

    func testParsingUsers() {
        let getUsersExpectation = expectation(description: "getUsers")
        userService.getUsers { result in
            switch result {
            case .success(let users):
                print("Users:\n \(users.map({ $0.description }).joined(separator: "\n"))")
            case .failure(let error):
                XCTFail("Error Parsing Users Response: \(error.description)")
            }
            getUsersExpectation.fulfill()
        }
        waitForExpectations(timeout: 90, handler: nil)
    }

    func getStubClosure<Target: TargetType>(target: Target) -> Moya.StubBehavior {
        return .immediate
    }
}
