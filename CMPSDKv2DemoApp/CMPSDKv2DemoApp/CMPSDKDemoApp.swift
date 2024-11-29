//
//  CMPSDKDemoAppApp.swift
//  CMPSDKDemoApp
//
//  Created by Fabio Torre on 07/10/24.
//

import SwiftUI

@main
struct CMPSDKDemoApp: App {
    // Add the @Environment property wrapper to access the scene phase
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var lifecycleManager = AppLifecycleManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(lifecycleManager)
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    lifecycleManager.handleScenePhaseChange(newPhase)
                }
        }
    }
}
