//
//  PasscodeButton.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 3/25/24.
//

import SwiftUI

/// A view representing a button used for entering passcode digits.
///
/// The `PasscodeButton` view displays a button with a number or label that
/// users can tap to enter a digit in the passcode input field.
struct PasscodeButton: View {
    /// The number or label displayed on the button.
    var number: String
    
    /// The action to be performed when the button is tapped.
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(number)
                .font(.title)
                .fontWeight(.semibold)
                .frame(width: 80, height: 80)
                .foregroundColor(.primary)
                .background(Color(.systemGray5))
                .cornerRadius(40)
        }
    }
}

struct PasscodeButton_Previews: PreviewProvider {
    static var previews: some View {
        PasscodeButton(number: "1", action: {})
    }
}
