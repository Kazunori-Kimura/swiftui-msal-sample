//
//  ContentView.swift
//  MsalSample
//
//  Created by Kazunori Kimura on 2024/01/30.
//

import SwiftUI
import Factory

struct ContentView: View {
    @EnvironmentObject var appContext: AppContext
    @StateObject var viewModel = ContentViewModel()
    
    @Injected(\.authService) private var authService
    
    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(appContext.userIsLogedIn ? "ログイン中": "ログインしてください")
            
            Text(viewModel.username)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            
            Button("Login") {
                authService.login(withInteraction: true)
            }
            .disabled(appContext.userIsLogedIn)
            
            Button("ユーザー情報の取得") {
                Task {
                    await viewModel.getCurrentUser()
                }
            }
            .disabled(!appContext.userIsLogedIn)
            
            Button("Logout") {
                authService.logout()
            }
            .disabled(!appContext.userIsLogedIn)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
