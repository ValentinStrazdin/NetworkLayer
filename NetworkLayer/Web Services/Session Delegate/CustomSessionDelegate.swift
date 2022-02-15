//
//  CustomSessionDelegate.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/15/22.
//

import Foundation
import Alamofire
import TrustKit

public final class CustomSessionDelegate: SessionDelegate {
    private let sslPinningEnabled: Bool

    init(sslPinningEnabled: Bool = false) {
        self.sslPinningEnabled = sslPinningEnabled
        super.init()
    }

    private func urlSession(_ session: URLSession,
                            didReceive challenge: URLAuthenticationChallenge,
                            completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if sslPinningEnabled {
            let pinningValidator = TrustKit.sharedInstance().pinningValidator
            // Pass the authentication challenge to the validator; if the validation fails, the connection will be blocked
            if !pinningValidator.handle(challenge, completionHandler: completionHandler) {
                // TrustKit did not handle this challenge: perhaps it was not for server trust
                // or the domain was not pinned. Fall back to the default behavior
                completionHandler(.performDefaultHandling, nil)
            }
        } else {
            // Trust any server to fix ssl errors and app hangs for strong ciphers
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
               let trust = challenge.protectionSpace.serverTrust {
                let credential = URLCredential(trust: trust)
                completionHandler(.useCredential, credential)
            }
        }
    }
}

