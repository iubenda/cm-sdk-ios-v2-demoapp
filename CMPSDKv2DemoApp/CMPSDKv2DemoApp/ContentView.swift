//
//  ContentView 2.swift
//  CMPSDKv2DemoApp
//
//  Created by Fabio Torre on 23/10/24.
//

import SwiftUI
import CmpSdk
import Combine

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @EnvironmentObject var lifecycleManager: AppLifecycleManager

    var body: some View {
        ZStack {
            if viewModel.showConsentControls {
                ConsentControlsView()
            } else {
                LoadingView()
            }
            
            if viewModel.showConsentWebView {
                ConsentWebView()
            }
        }
        .onChange(of: lifecycleManager.canInitializeCMP) { canInitialize in
            if canInitialize {
                viewModel.initializeCMP()
            }
        }
    }
}

class ContentViewModel: ObservableObject {
    @Published var showConsentControls = false
    @Published var showConsentWebView = false
    
    init() {
        setupNotifications()
    }
    
    func initializeCMP() {
        CMPManager.shared.initialize()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.showConsentControls = true
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCMPClosed),
            name: .cmpClosed,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCMPOpened),
            name: .cmpOpened,  // You'll need to add this notification name
            object: nil
        )
    }
    
    @objc private func handleCMPOpened() {
        DispatchQueue.main.async {
            self.showConsentWebView = true
        }
    }

    @objc private func handleCMPClosed() {
        DispatchQueue.main.async {
            self.showConsentWebView = false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
