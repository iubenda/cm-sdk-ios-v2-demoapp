//
//  ATTManager.swift
//  CMPSDKv2DemoApp
//
//  Created by Fabio Torre on 29/11/24.
//

import AppTrackingTransparency
import UIKit

class ATTManager {
    // Singleton instance for app-wide access
    static let shared = ATTManager()
    
    // Track if ATT flow has been completed to avoid duplicate requests
    private var isATTCompleted = false
    // Store completion handler for deferred execution
    private var pendingCompletion: (() -> Void)?
    
    private init() {}
    
    func requestTrackingAuthorization(completion: @escaping () -> Void) {
        // If ATT is already completed, call completion immediately
        guard !isATTCompleted else {
            completion()
            return
        }
        
        // Store the completion handler for when we can actually show the dialog
        pendingCompletion = completion
        
        // We'll trigger the actual request when the app becomes active
        checkStateAndRequestAuthorization()
    }
    
    func checkStateAndRequestAuthorization() {
        // Ensure we're on the main thread
        DispatchQueue.main.async {
            // Only proceed if we have a pending request
            guard let completion = self.pendingCompletion else { return }
            
            if #available(iOS 14, *) {
                // Check current authorization status
                let currentStatus = ATTrackingManager.trackingAuthorizationStatus
                
                // Only show dialog if status is not determined
                if currentStatus == .notDetermined {
                    print("ATT: Requesting authorization")
                    ATTrackingManager.requestTrackingAuthorization { status in
                        self.handleAuthorizationCompletion(status: status, completion: completion)
                    }
                } else {
                    // If status is already determined, complete immediately
                    print("ATT: Status already determined: \(currentStatus)")
                    self.handleAuthorizationCompletion(status: currentStatus, completion: completion)
                }
            } else {
                // For iOS versions < 14, complete immediately
                self.isATTCompleted = true
                self.pendingCompletion = nil
                completion()
            }
        }
    }
    
    private func handleAuthorizationCompletion(
        status: ATTrackingManager.AuthorizationStatus,
        completion: @escaping () -> Void
    ) {
        switch status {
        case .authorized:
            print("ATT: User authorized tracking")
        case .denied:
            print("ATT: User denied tracking")
        case .restricted:
            print("ATT: Tracking is restricted")
        case .notDetermined:
            print("ATT: Tracking authorization status not determined")
        @unknown default:
            print("ATT: Unknown authorization status")
        }
        
        self.isATTCompleted = true
        self.pendingCompletion = nil
        
        // Notify completion on main thread
        DispatchQueue.main.async {
            completion()
        }
    }
}
