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
    }
}

class ContentViewModel: ObservableObject {
    @Published var showConsentControls = false
    @Published var showConsentWebView = true
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupNotifications()
        setupBindings()
        initializeCMP()
    }
    
    private func setupBindings() {
        // Observe CMPManager's isConsentLayerVisible property
        CMPManager.shared.$isConsentLayerVisible
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isVisible in
                self?.showConsentWebView = isVisible
            }
            .store(in: &cancellables)
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCMPClosed),
            name: .cmpClosed,
            object: nil
        )
    }
    
    private func initializeCMP() {
        CMPManager.shared.initialize()
        self.showConsentControls = true
    }

    @objc private func handleCMPClosed() {
        DispatchQueue.main.async {
            self.showConsentWebView = false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        cancellables.removeAll()
    }
}
