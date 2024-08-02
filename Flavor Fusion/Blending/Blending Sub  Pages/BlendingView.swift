//
//  BlendingView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 7/13/24.
//

import SwiftUI

/// A view that displays a blending progress message and a button to complete the blending process.
///
/// `BlendingView` shows a "Blending..." message, a progress indicator, and a "Complete Blending" button.
/// When the button is pressed, the blending process is simulated with a delay before calling the `onComplete` closure.
///
/// - Parameters:
///   - onComplete: A closure that is called when the blending process is completed.
struct BlendingView: View {
    let onComplete: () -> Void

    var body: some View {
        VStack {
            Text("Blending...")
                .font(.largeTitle)
                .padding(.top)

            ProgressView()
                .padding()

            Spacer()

            // Simulate a blending process with a delay
            Button(action: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    onComplete()
                }
            }) {
                Text("Complete Blending")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    BlendingView(onComplete: {})
}
