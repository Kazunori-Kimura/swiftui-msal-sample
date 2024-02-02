//
//  AuthState.swift
//  MsalSample
//
//  Created by Kazunori Kimura on 2024/02/01.
//

import Foundation

protocol AuthStateType {
    var userIsLogedIn: Bool { get set }
    var account: Account? { get set }
}

class AuthState: ObservableObject, AuthStateType {
    @Published var userIsLogedIn: Bool = false
    @Published var account: Account?
}

struct Account: Equatable {
    let email: String?
    let accessToken: String?
    
    init(email: String?, accessToken: String?) {
        self.email = email
        self.accessToken = accessToken
    }
    init(email: String?) {
        self.email = email
        self.accessToken = nil
    }
}
