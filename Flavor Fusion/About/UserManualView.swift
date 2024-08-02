//
//  UserManualView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 4/6/24.
//

import SwiftUI

/// A view that provides the user manual for the Flavor Fusion device.
///
/// `UserManualView` displays sections with instructions on getting started, using the device,
/// and troubleshooting common issues.
struct UserManualView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SectionView(title: "Getting Started") {
                    BulletPoint(text: "Unbox Flavor Fusion.")
                    BulletPoint(text: "Plug in the device to a power source.")
                    BulletPoint(text: "Download the Flavor Fusion mobile app from the App Store.")
                }
                
                SectionView(title: "Using the Device") {
                    BulletPoint(text: "Press the power button to turn on/off the device.")
                    BulletPoint(text: "Refill spice cartridges when empty.")
                }
                
                SectionView(title: "Troubleshooting") {
                    BulletPoint(text: "If the device does not turn on, check the power connection.")
                    BulletPoint(text: "If the LCD screen is unresponsive, restart the device.")
                    BulletPoint(text: "For any other issues, refer to the user manual or contact customer support.")
                }
            }
            .padding()
        }
    }
}

/// A view that represents a section in the user manual.
///
/// `SectionView` displays a section title and a list of bullet points with instructions or information.
///
/// - Parameters:
///   - title: The title of the section.
///   - content: The content of the section.
struct SectionView<Content: View>: View {
    var title: String
    var content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            content
        }
    }
}

/// A view that represents a bullet point in the user manual.
///
/// `BulletPoint` displays a bullet point with the provided text.
///
/// - Parameters:
///   - text: The text of the bullet point.
struct BulletPoint: View {
    var text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 5) {
            Text("•")
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

// Preview Provider for the UserManualView
#Preview {
    UserManualView()
}
