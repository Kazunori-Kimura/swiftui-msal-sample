//
//  AppContext.swift
//  MsalSample
//
//  Created by Kazunori Kimura on 2024/02/02.
//

import Foundation

class AppContext: ObservableObject {
    @Published var userIsLogedIn: Bool = false
    @Published var accessToken: String? = nil
}
