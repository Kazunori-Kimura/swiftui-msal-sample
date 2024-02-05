//
//  ContentViewModel.swift
//  MsalSample
//
//  Created by Kazunori Kimura on 2024/02/02.
//

import SwiftUI
import Factory
import OSLog

class ContentViewModel: ObservableObject {
    @Published var username: String = ""
    
    @Injected(\.fetchService)
    private var fetchService
    
    @MainActor
    func getCurrentUser() async {
        do {
            let user: MNDao.MNUser = try await fetchService.callAPI(path: "/user/regist", method: "POST")
            self.username = user.email
        } catch {
            Logger.api.error("Error: \(error.localizedDescription)")
        }
    }
}
