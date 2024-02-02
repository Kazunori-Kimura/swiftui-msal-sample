//
//  AuthCredentials.swift
//  MsalSample
//
//  Created by Kazunori Kimura on 2024/02/01.
//

import Foundation

protocol AuthCredentialsType {
    var domain: String { get }
    var authorityUrl: String { get }
    var resetUrl: String { get }
    var appId: String { get }
    var clientId: String { get }
    var clientSecret: String { get }
    var scopes: [String] { get }
}

class AuthCredentials: AuthCredentialsType {
    let domain: String
    let authorityUrl: String
    let resetUrl: String
    let appId: String
    let clientId: String
    let clientSecret: String
    let scopes: [String]
    
    init() {
        self.domain = Bundle.getBundleString(key: "B2C_DOMAIN")
        self.authorityUrl = Bundle.getBundleString(key: "B2C_AUTHORITY")
        self.resetUrl = Bundle.getBundleString(key: "B2C_RESET")
        self.appId = Bundle.getBundleString(key: "B2C_APP_ID")
        self.clientId = Bundle.getBundleString(key: "B2C_CLIENT_ID")
        self.clientSecret = Bundle.getBundleString(key: "B2C_CLIENT_SECRET")
        self.scopes = Bundle.getBundleArray(key: "B2C_SCOPES")
    }
}
