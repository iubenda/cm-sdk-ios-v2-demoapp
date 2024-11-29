//
//  AppLifecycleManager.swift
//  CMPSDKv2DemoApp
//
//  Created by Fabio Torre on 29/11/24.
//

import Foundation
import SwiftUI

// Manages app lifecycle and coordinates between ATT and CMP
class AppLifecycleManager: ObservableObject {
    @Published var canInitializeCMP = false
    private var hasHandledInitialActivation = false
    
    func handleScenePhaseChange(_ phase: ScenePhase) {
        switch phase {
        case .active:
            // Only handle the initial activation once
            guard !hasHandledInitialActivation else { return }
            hasHandledInitialActivation = true
            
            // Request ATT authorization when app becomes active
            ATTManager.shared.requestTrackingAuthorization { [weak self] in
                DispatchQueue.main.async {
                    // Small delay to ensure ATT UI is completely dismissed
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.canInitializeCMP = true
                    }
                }
            }
        default:
            break
        }
    }
}
