# consentmanager CMP SDK v2 DemoApp

A SwiftUI demo application showcasing the integration and functionality of the consentmanager CMP (Consent Management Platform) SDK v2 for iOS. This app demonstrates how to implement and interact with various consent management features.

For more information about the Consentmanager CMP SDK, visit [consentmanager.net](https://consentmanager.net) and our [help documentation](https://help.consentmanager.net/books/cmp/chapter/integration-into-your-app).

## Overview

This demo app provides a comprehensive interface to test and validate the CMP SDK's functionality, including:
- Consent status checking
- Purpose and vendor management
- Consent string handling
- UI layer integration

## Architecture

### Key Components

- `CMPManager`: A singleton wrapper around the CMP SDK that handles:
  - SDK initialization and configuration
  - Event handling (errors, UI open/close events)
  - Notification broadcasting
  
- `ContentView`: The main view container that manages:
  - Loading state
  - Consent WebView visibility
  - Controls visibility

- `ConsentControlsView`: A SwiftUI interface providing buttons to interact with all major SDK features

### Features Demonstrated

1. **Basic SDK Setup**
   - SDK initialization with custom configuration
   - Event listener registration
   - Error handling

2. **Consent Management**
   - Check user consent status
   - Get/Set consent string
   - Import external consent strings
   - Accept/Reject all consents

3. **Purpose Management**
   - List all purposes
   - Check specific purpose consent
   - Enable/Disable individual purposes
   - Get enabled/disabled purposes

4. **Vendor Management**
   - List all vendors
   - Check specific vendor consent
   - Enable/Disable individual vendors
   - Get enabled/disabled vendors

5. **UI Integration**
   - Consent layer display
   - Toast notifications for action feedback
   - Loading states
   - WebView integration

## Usage

### Initialization

```swift
let cmpConfig = CmpConfig.shared.setup(
    withId: "Your Code-ID goes here (13 characters)",
    domain: "delivery.consentmanager.net",
    appName: "CMPSDKv2DemoApp",
    language: "IT"
)
```

### Basic Consent Operations

```swift
// Check if user has made a choice
CMPManager.shared.cmpManager?.hasConsent()

// Accept all consents
CMPManager.shared.cmpManager?.acceptAll { 
    // Handle completion
}

// Reject all consents
CMPManager.shared.cmpManager?.rejectAll {
    // Handle completion
}
```

### Purpose/Vendor Management

```swift
// Enable specific purposes
CMPManager.shared.cmpManager?.enablePurposeList(["c52", "c53"])

// Enable specific vendors
CMPManager.shared.cmpManager?.enableVendorList(["s2790", "s2791"])

// Check specific consent
CMPManager.shared.cmpManager?.hasPurposeConsent("c53")
CMPManager.shared.cmpManager?.hasVendorConsent("s2789")
```

## UI Components

- `LoadingView`: Displays initialization progress
- `ConsentWebView`: Renders the CMP consent interface
- `ConsentControlsView`: Provides interactive buttons for all SDK features
- `ToastView`: Shows feedback messages for user actions

## Event Handling

The app demonstrates proper event handling through:
- Error callbacks
- Open/Close events
- Button click tracking
- NotificationCenter broadcasts

## Tips for Implementation

1. Always initialize the SDK before accessing any features
2. Handle the consent WebView visibility through NotificationCenter observers
3. Implement proper error handling for all SDK operations
4. Use the async/await pattern for consent string imports
5. Maintain a single instance of CMPManager throughout the app lifecycle

## Requirements

- CmpSdk framework version 2.5.3

## Note

This demo app is designed to showcase the integration patterns and available features of the CMP SDK. In a production environment, you would need to:
- Add proper error handling
- Implement persistence if required
- Add proper loading states
- Handle edge cases
- Add proper logging
