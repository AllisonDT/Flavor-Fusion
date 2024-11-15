//
//  TeamView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 10/8/24.
//

import SwiftUI

/// A view that displays the team members of Flavor Fusion.
///
/// `TeamView` shows a grid of team members with their pictures, names, and positions.
/// Tapping on a team member presents their biography in a modal sheet.
struct TeamView: View {
    /// An array containing the team members, their positions, and biographies.
    let teamMembers = [
        TeamMember(name: "Ryan Latterell", position: "Project Manager", biography: "Ryan's Biography", imageName: "ryan"),
        TeamMember(name: "Allison Turner", position: "App Developer", biography: "Allison's Biography", imageName: "allison"),
        TeamMember(name: "Samuel Pabon", position: "Electronics Engineer", biography: "Sam's Biography", imageName: "sam"),
        TeamMember(name: "Alexandra Figueroa", position: "CAD Queen", biography: "Alex's Biography", imageName: "alex"),
        TeamMember(name: "Thomas Spurlock", position: "Engineer", biography: "Thomas' Biography", imageName: "thomas"),
        TeamMember(name: "Ethan Butterfield", position: "Engineer", biography: "Ethan's Biography", imageName: "ethan")
    ]
    
    @State private var selectedMember: TeamMember? = nil

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            
            VStack(spacing: 20) {
                // Iterating through rows
                ForEach(0..<3) { row in
                    HStack(spacing: 20) {
                        // Iterating through columns
                        ForEach(0..<2) { column in
                            if let index = self.indexFor(row: row, column: column) {
                                // Displaying team member view
                                TeamMemberView(member: self.teamMembers[index], showImage: !isLandscape)
                                    .onTapGesture {
                                        self.selectedMember = self.teamMembers[index]
                                    }
                            } else {
                                Spacer()
                            }
                        }
                    }
                }
            }
            .padding()
            .sheet(item: $selectedMember) { member in
                BiographyView(member: member)
            }
        }
    }

    /// Calculates the index for the team members array based on the row and column.
    ///
    /// - Parameters:
    ///   - row: The row index.
    ///   - column: The column index.
    /// - Returns: The index for the team members array or nil if out of bounds.
    func indexFor(row: Int, column: Int) -> Int? {
        let index = row * 2 + column
        return index < teamMembers.count ? index : nil
    }
}

// Preview Provider for the TeamView
#Preview {
    TeamView()
}
