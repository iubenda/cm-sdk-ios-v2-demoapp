//
//  CMPManager.swift
//  CMPSDKv2DemoApp
//
//  Created by Fabio Torre on 24/10/24.
//

import Foundation
import CmpSdk

class CMPSDKManager {
    static let shared = CMPSDKManager()
    
    private(set) var cmpManager: CmpManager?
    private var isInitialized = false
    @Published private(set) var isConsentLayerVisible = false

    private init() {}
    
    func initialize() {
        
        guard cmpManager == nil else { return }
        
        let cmpConfig: CmpConfig = CmpConfig.shared.setup(
            withId: "YOUR-CODE-ID-GOES-HERE",  // TODO: replace this by your Code-ID (13 characters)
            domain: "delivery.consentmanager.net",
            appName: "CMPSDKv2DemoApp",
            language: "DE")
        
        cmpConfig.logLevel = CmpLogLevel.verbose
        cmpConfig.isAutomaticATTRequest = false
        
        let manager = CmpManager(cmpConfig: cmpConfig)
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
        NotificationCenter.default.post(name: .cmpOpened, object: nil)
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
    static let cmpOpened = Notification.Name("CMPOpenedNotification")  // Add this line
}
