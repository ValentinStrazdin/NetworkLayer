//
//  DependencyContainer.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 1/30/22.
//

import Foundation
import Moya

public class DependencyContainer: HasUserService {
    static let shared = DependencyContainer()

    // This is the URLSession where we setup our custom configuration
    private lazy var session: Session = {
        Session(configuration: .defaultConfig)
    }()

    // MARK: - Moya Providers
    private lazy var userProvider: MoyaProvider<UserApi> = {
        MoyaProvider<UserApi>(session: session, plugins: plugins)
//        MoyaProvider<UserApi>(stubClosure: getStubClosure, session: session, plugins: plugins)
    }()

    // MARK: - Services
    lazy var userService: UserServiceProtocol = {
        UserService(provider: userProvider)
    }()

    // MARK: - Moya Plugins
    private let networkLoggerConfiguration = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
    private var plugins: [PluginType] {
        [NetworkLoggerPlugin(configuration: networkLoggerConfiguration)]
    }

    func getStubClosure<Target: TargetType>(target: Target) -> Moya.StubBehavior {
        return .immediate
    }
}
