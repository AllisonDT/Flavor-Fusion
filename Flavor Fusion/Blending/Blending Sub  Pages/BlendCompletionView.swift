//
//  BlendCompletionView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 7/13/24.
//

import SwiftUI

/// A view that displays the completion message after blending.
///
/// `BlendCompletionView` shows a "Complete!" message, an image, a randomly selected
/// fun message, and a "Done" button. When the button is pressed, it calls the `onDone` closure.
///
/// - Parameters:
///   - onDone: A closure that is called when the "Done" button is pressed.
struct BlendCompletionView: View {
    let onDone: () -> Void

    // Array of fun complete messages
    let completeMessages = [
        "Have a spicy day!",
        "You're on fire!",
        "Spice up your life!",
        "Blend it like it's hot!",
        "Keep it spicy!"
    ]

    // Randomly select a message from the array
    var randomMessage: String {
        completeMessages.randomElement() ?? "Have a spicy day!"
    }

    var body: some View {
        VStack {
            Text("Complete!")
                .font(.largeTitle)
                .padding(.top)

            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
                .padding()

            Text(randomMessage)
                .font(.title2)
                .padding(.top)

            Spacer()

            Button(action: onDone) {
                Text("Done")
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: onDone) {
            Image(systemName: "xmark")
                .foregroundColor(.primary)
        })
    }
}

struct BlendCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BlendCompletionView(onDone: {})
        }
    }
}
