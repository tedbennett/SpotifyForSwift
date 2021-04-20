//
//  File.swift
//  
//
//  Created by Ted Bennett on 19/04/2021.
//

import Foundation

struct PkceParams {
    let verifier: String
    let clientId: String
    let redirectUri: String
}

struct AuthParams {
    let accessToken: String
    let refreshToken: String?
    let expiry: Date
    
    init(accessToken: String, refreshToken: String? = nil, expiry: Date) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiry = expiry
    }
    
    init?(json: [String: Any]) {
        guard let accessToken = json["access_token"] as? String,
              let refreshToken = json["refresh_token"] as? String,
              let expiresIn = json["expires_in"] as? Int else {
            return nil
        }
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiry = Date(timeIntervalSinceNow: TimeInterval(expiresIn))
    }
}
