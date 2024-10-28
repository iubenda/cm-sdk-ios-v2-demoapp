//
//  LoadingView.swift
//  CMPSDKv2DemoApp
//
//  Created by Fabio Torre on 24/10/24.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Initializing Consent Manager...")
                .font(.headline)
                .padding(.top)
        }
    }
}
