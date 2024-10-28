//
//  CMPManager.swift
//  CMPSDKv2DemoApp
//
//  Created by Fabio Torre on 24/10/24.
//

import Foundation
import CmpSdk

class CMPManager {
    static let shared = CMPManager()
    
    private(set) var cmpManager: CMPConsentTool?
    private var isInitialized = false
    @Published private(set) var isConsentLayerVisible = false

    private init() {}
    
    func initialize() {
        
        guard cmpManager == nil else { return }
        
        let cmpConfig: CmpConfig = CmpConfig.shared.setup(
            withId: "Your Code-ID goes here",  // TODO: replace this with the 13 character Code-ID from your CMP
            domain: "delivery.consentmanager.net",
            appName: "CMPSDKv2DemoApp",
            language: "EN")
        
        cmpConfig.logLevel = CmpLogLevel.verbose
        cmpConfig.isAutomaticATTRequest = true
        
        let manager = CMPConsentTool(cmpConfig: cmpConfig)
            .withErrorListener(handleError)
            .withCloseListener(handleClose)
            .withOpenListener(handleOpen)
            .withOnCMPNotOpenedListener(handleNotOpened)
            .withOnCmpButtonClickedCallback(handleButtonClick)
        
        cmpManager = manager
        manager?.initialize()
        isInitialized = true
    }
    
    // MARK: - Event Handlers
    private func handleError(type: CmpErrorType, message: String?) {
        print("CMP Error: \(type) - \(message ?? "No message")")
        isConsentLayerVisible = false
    }
    
    private func handleClose() {
        isConsentLayerVisible = false
        NotificationCenter.default.post(name: .cmpClosed, object: nil)
    }
    
    private func handleOpen() {
        isConsentLayerVisible = true
        print("CMP Opened")
    }
    
    private func handleNotOpened() {
        isConsentLayerVisible = false
        print("CMP Not Opened")
    }
    
    private func handleButtonClick(event: CmpButtonEvent) {
        print("Button clicked: \(event)")
    }
}

// Notification extension
extension Notification.Name {
    static let cmpClosed = Notification.Name("CMPClosedNotification")
}
