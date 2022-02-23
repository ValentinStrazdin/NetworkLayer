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
    // This is the URLSession where we setup our custom configuration
    private lazy var session: Session = {
        Session(configuration: .defaultConfig)
    }()
    
    // MARK: - Moya Providers
    private lazy var userProvider: MoyaProvider<UserApi> = {
        MoyaProvider<UserApi>(session: session, plugins: plugins)
    }()
    
    // MARK: - Moya Plugins
    private let networkLoggerConfiguration = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
    private var plugins: [PluginType] {
        [NetworkLoggerPlugin(configuration: networkLoggerConfiguration)]
    }

    // MARK: - Services
    private lazy var userService: UserServiceProtocol = {
        UserService(provider: userProvider)
    }()

    func testGetUsers() {
        let getUsersExpectation = expectation(description: "getUsers")
        _ = userService.getUsers { result in
            switch result {
            case .success(let users):
                print("Users:\n \(users.map({ $0.description }).joined(separator: "\n"))")
            case .failure(let error):
                XCTFail(error.description)
            }
            getUsersExpectation.fulfill()
        }
        waitForExpectations(timeout: 90, handler: nil)
    }

    func testCreateUser() {
        let createUserExpectation = expectation(description: "createUser")
        _ = userService.createUser(TestConstants.userModel) { result in
            switch result {
            case .success:
                print("User successfully created")
            case .failure(let error):
                XCTFail(error.description)
            }
            createUserExpectation.fulfill()
        }
        waitForExpectations(timeout: 90, handler: nil)
    }

    func testUpdateUser() {
        let updateUserExpectation = expectation(description: "updateUser")
        _ = userService.updateUser(id: TestConstants.userId,
                               user: TestConstants.userModel) { result in
            switch result {
            case .success:
                print("User successfully updated")
            case .failure(let error):
                XCTFail(error.description)
            }
            updateUserExpectation.fulfill()
        }
        waitForExpectations(timeout: 90, handler: nil)
    }

    func testDeleteUser() {
        let deleteUserExpectation = expectation(description: "deleteUser")
        _ = userService.deleteUser(id: TestConstants.userId) { result in
            switch result {
            case .success:
                print("User successfully deleted")
            case .failure(let error):
                XCTFail(error.description)
            }
            deleteUserExpectation.fulfill()
        }
        waitForExpectations(timeout: 90, handler: nil)
    }
}

