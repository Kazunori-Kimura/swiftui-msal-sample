//
//  AuthCredentials.swift
//  MsalSample
//
//  Created by Kazunori Kimura on 2024/02/01.
//

import Foundation

class AuthCredentials {
    let authorityUrl: String
    let appId: String
    let clientSecret: String
    let scopes: [String]
    
    init() {
        self.authorityUrl = Bundle.getBundleString(key: "B2C_AUTHORITY")
        self.appId = Bundle.getBundleString(key: "B2C_APP_ID")
        self.clientSecret = Bundle.getBundleString(key: "B2C_CLIENT_SECRET")
        self.scopes = Bundle.getBundleArray(key: "B2C_SCOPES")
    }
}
