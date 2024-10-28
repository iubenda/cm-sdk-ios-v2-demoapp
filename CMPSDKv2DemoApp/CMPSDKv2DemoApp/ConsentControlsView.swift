//
//  ConsentControlsView.swift
//  CMPSDKv2DemoApp
//
//  Created by Fabio Torre on 24/10/24.
//

import Foundation
import SwiftUI

struct ConsentControlsView: View {
    @State private var toastMessage: String?
    
    var body: some View {
        ZStack {  // Changed from ScrollView to ZStack
            ScrollView {
                VStack(spacing: 20) {
                    Text("CM Swift DemoApp")
                        .font(.largeTitle)
                        .bold()
                    
                    ConsentButtons(showToast: showToast)
                }
                .padding()
            }
            
            ToastView(message: $toastMessage)  // Now a direct child of ZStack
        }
    }
    
    private func showToast(_ message: String) {
        toastMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            toastMessage = nil
        }
    }
}

struct ConsentButtons: View {
    let showToast: (String) -> Void

    var body: some View {
        VStack(spacing: 12) {
            ConsentButton(title: "Has User Choice?", color: .blue) {
                let hasConsent = CMPManager.shared.cmpManager?.hasConsent()
                showToast("Has User Choice: \(String(describing: hasConsent))")
            }
            
            ConsentButton(title: "Get CMP String", color: .teal) {
                let cmpString = CMPManager.shared.cmpManager?.getConsentString()
                showToast("CMP String: \(String(describing: cmpString))")
            }
            
            ConsentButton(title: "Get All Purposes", color: .mint) {
                let purposes = CMPManager.shared.cmpManager?.getAllPurposes()
                showToast("Purposes: \(String(describing: purposes))")
            }
            
            ConsentButton(title: "Has Purpose ID c53?", color: .mint) {
                let hasPurpose = CMPManager.shared.cmpManager?.hasPurposeConsent("c53")
                showToast("Has Purpose c53: \(String(describing: hasPurpose))")
            }
            
            ConsentButton(title: "Get Enabled Purposes", color: .mint) {
                let enabled = CMPManager.shared.cmpManager?.getEnabledPurposes()
                showToast("Enabled Purposes: \(String(describing: enabled))")
            }
            
            ConsentButton(title: "Get Disabled Purposes", color: .gray) {
                let disabled = CMPManager.shared.cmpManager?.getDisabledPurposes()
                showToast("Disabled Purposes: \(String(describing: disabled))")
            }
            
            ConsentButton(title: "Enable Purposes c52 and c53", color: .mint) {
                CMPManager.shared.cmpManager?.enablePurposeList(["c52", "c53"])
                showToast("Purposes c52 and c53 enabled.")
            }
            
            ConsentButton(title: "Disable Purposes c52 and c53", color: .red) {
                CMPManager.shared.cmpManager?.disablePurposeList(["c52", "c53"])
                showToast("Purposes c52 and c53 disabled")
            }
            
            ConsentButton(title: "Get All Vendors", color: .cyan) {
                let vendors = CMPManager.shared.cmpManager?.getAllVendors()
                showToast("All Vendors: \(String(describing: vendors))")
            }
            
            ConsentButton(title: "Has Vendor ID s2789?", color: .cyan) {
                let hasVendor = CMPManager.shared.cmpManager?.hasVendorConsent("s2789")
                showToast("Has Vendor s2789: \(String(describing: hasVendor))")
            }
            
            ConsentButton(title: "Get Enabled Vendors", color: .cyan) {
                let enabled = CMPManager.shared.cmpManager?.getEnabledVendors()
                showToast("Enabled Vendors: \(String(describing: enabled))")
            }
            
            ConsentButton(title: "Get Disabled Vendors", color: .gray) {
                let disabled = CMPManager.shared.cmpManager?.getDisabledVendors()
                showToast("Disabled Vendors: \(String(describing: disabled))")
            }
            
            ConsentButton(title: "Enable Vendors s2790 and s2791", color: .cyan) {
                CMPManager.shared.cmpManager?.enableVendorList(["s2790", "s2791"])
                showToast("Vendors s2790 and s2791 enabled")
            }
            
            ConsentButton(title: "Disable Vendors s2790 and s2791", color: .red) {
                CMPManager.shared.cmpManager?.disableVendorList(["s2790", "s2791"])
                showToast("Vendors s2790 and s2791 disabled")
            }
            
            ConsentButton(title: "Reject All", color: .red) {
                CMPManager.shared.cmpManager?.rejectAll {
                    showToast("All consents rejected")
                }
            }
            
            ConsentButton(title: "Accept All", color: .green) {
                CMPManager.shared.cmpManager?.acceptAll {
                    showToast("All consents accepted")
                }
            }
            
            ConsentButton(title: "Check and Open Consent Layer", color: .indigo) {
                CMPManager.shared.cmpManager?.checkAndOpenConsentLayer()
            }
            
            ConsentButton(title: "Open Consent Layer", color: .indigo) {
                CMPManager.shared.cmpManager?.openView()
            }
            
            ConsentButton(title: "Import CMP String", color: .mint) {
                let cmpString = "Q1FERkg3QVFERkg3QUFmR01CSVRCQkVnQUFBQUFBQUFBQWlnQUFBQUFBQUEjXzUxXzUyXzUzXzU0XzU1XzU2XyNfczI3ODlfczI3OTBfczI3OTFfczI2OTdfczk3MV9VXyMxLS0tIw"
                importConsentString(cmpString, showToast: showToast)
            }
        }
    }
    
    private func importConsentString(_ cmpString: String, showToast: @escaping (String) -> Void) {
        Task {
            if let result = await CMPManager.shared.cmpManager?.importCmpString(cmpString) {
                let (success, error) = result
                await MainActor.run {
                    if success {
                        showToast("New consent string imported successfully")
                    } else {
                        showToast("Error: \(error ?? "Unknown error")")
                    }
                }
            }
        }
    }
}

struct ToastView: View {
    @Binding var message: String?
    
    var body: some View {
        GeometryReader { geometry in
            if let message = message {
                Text(message)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(10)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .ignoresSafeArea()
            }
        }
    }
}

struct ConsentButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(color)
                .cornerRadius(10)
        }
    }
}
