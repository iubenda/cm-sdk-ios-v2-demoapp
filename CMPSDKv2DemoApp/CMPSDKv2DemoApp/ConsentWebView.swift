//
//  ConsentWebView.swift
//  CMPSDKv2DemoApp
//
//  Created by Fabio Torre on 24/10/24.
//

import Foundation
import SwiftUI

struct ConsentWebView: View {
    var body: some View {
        Color.black.opacity(0.4)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                Text("CMP WebView")
                    .font(.headline)
                    .foregroundColor(.white)
            )
    }
}
