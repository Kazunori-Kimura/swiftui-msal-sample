//
//  Container.swift
//  MsalSample
//
//  Created by Kazunori Kimura on 2024/02/01.
//

import Factory

extension Container {
    var authCredentials: Factory<AuthCredentialsType> {
        Factory(self) { AuthCredentials() }
            .singleton
    }
    var authState: Factory<AuthStateType> {
        Factory(self) { AuthState() }
            .singleton
    }
    var authService: Factory<AuthServiceProtocol> {
        Factory(self) { AuthService() }
            .singleton
    }
}
