//
//  DependencyContainer.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 1/30/22.
//

import Foundation
import Moya

public class DependencyContainer: HasAuthenticationManager, HasLoginService, HasUserService {
    static let shared = DependencyContainer()

    lazy var authenticationManager: AuthenticationManagerProtocol = {
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
//        MoyaProvider<UserApi>(stubClosure: getStubClosure, session: session, plugins: plugins)
    }()

    // MARK: - Services
    lazy var loginService: LoginServiceProtocol = {
        LoginService(provider: loginProvider)
    }()

    lazy var userService: UserServiceProtocol = {
        UserService(provider: userProvider)
    }()

    // MARK: - Moya Plugins
    private let networkLoggerConfiguration = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
    private var plugins: [PluginType] {
        [accessTokenPlugin, NetworkLoggerPlugin(configuration: networkLoggerConfiguration)]
    }

    private lazy var accessTokenPlugin: AccessTokenPlugin = {
        AccessTokenPlugin(tokenClosure: getAuthorizationToken)
    }()

    func getAuthorizationToken(authorizationType: AuthorizationType) -> String {
        authenticationManager.token ?? ""
    }

    func getStubClosure<Target: TargetType>(target: Target) -> Moya.StubBehavior {
        return .immediate
    }
}
