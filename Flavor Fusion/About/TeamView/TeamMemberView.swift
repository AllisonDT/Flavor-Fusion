//
//  TeamMemberView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 10/8/24.
//

import SwiftUI

/// A view that displays an individual team member.
///
/// `TeamMemberView` shows the team member's picture or a default silhouette, name, and position.
///
/// - Parameters:
///   - member: The team member to be displayed.
///   - showImage: A Boolean value indicating whether to show the image.
struct TeamMemberView: View {
    let member: TeamMember
    let showImage: Bool

    var body: some View {
        VStack {
            // Display team member's picture or silhouette if showImage is true
            if showImage {
                if let imageName = member.imageName, let uiImage = UIImage(named: imageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .padding(.bottom, 5)
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .padding(.bottom, 5)
                }
            }

            // Displaying team member's name and position
            Text(member.name)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(member.position)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 2, x: 0, y: 2)
    }
}
