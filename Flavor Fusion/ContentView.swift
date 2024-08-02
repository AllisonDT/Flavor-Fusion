//
//  ContentView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 2/5/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isFirstTimeOpen") private var isFirstTimeOpen: Bool = true
    
    var body: some View {
        if isFirstTimeOpen {
            CreatePasscode()
                .onDisappear {
                    // Update the flag to indicate the app has been opened before
                    isFirstTimeOpen = false
                }
        } else {
            LoginPasscode()
        }
    }
}

#Preview {
    ContentView()
}
