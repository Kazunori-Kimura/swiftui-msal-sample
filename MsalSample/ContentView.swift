//
//  ContentView.swift
//  MsalSample
//
//  Created by Kazunori Kimura on 2024/01/30.
//

import SwiftUI
import Factory

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @Injected(\.authService) private var authService
    
    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(viewModel.authState.account?.email ?? "ログインしてください")
            
            Button("Login") {
                authService.login(withInteraction: true)
            }
//            .disabled(viewModel.authState.userIsLogedIn)
            
            Button("Logout") {
                authService.logout()
            }
//            .disabled(!viewModel.authState.userIsLogedIn)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
