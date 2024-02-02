//
//  MsalSampleApp.swift
//  MsalSample
//
//  Created by Kazunori Kimura on 2024/01/30.
//

import SwiftUI
import Factory

@main
struct MsalSampleApp: App {
    @Environment(\.scenePhase) var scenePhase
    @Injected(\.authService) var authService
    @Injected(\.appContext) var appContext
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    authService.setupView()
                    authService.login(withInteraction: false)
                }
                .onChange(of: scenePhase, initial: false) { _, scenePhase in
                    if scenePhase == .active {
                        authService.login(withInteraction: false)
                    }
                }
                .onOpenURL { url in
                    authService.openUrl(url: url)
                }
                .environmentObject(appContext)
        }
    }
}
