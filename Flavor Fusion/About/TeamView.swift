//
//  TeamView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 3/24/24.
//

import SwiftUI

/// A struct representing a team member.
struct TeamMember: Identifiable {
    let id = UUID()
    let name: String
    let position: String
    let biography: String
    let imageName: String?
}

/// A view that displays the team members of Flavor Fusion.
///
/// `TeamView` shows a grid of team members with their pictures, names, and positions.
/// Tapping on a team member presents their biography in a modal sheet.
struct TeamView: View {
    /// An array containing the team members, their positions, and biographies.
    let teamMembers = [
        TeamMember(name: "Ryan Latterell", position: "Project Manager", biography: "Ryan's Biography", imageName: "ryan"),
        TeamMember(name: "Allison Turner", position: "Developer", biography: "Allison's Biography", imageName: "allison"),
        TeamMember(name: "Samuel Pabon", position: "Engineer", biography: "Sam's Biography", imageName: "sam"),
        TeamMember(name: "Alexandra Figueroa", position: "Engineer", biography: "Alex's Biography", imageName: "alex"),
        TeamMember(name: "Thomas Spurlock", position: "Engineer", biography: "Thomas' Biography", imageName: "thomas"),
        TeamMember(name: "Ethan Butterfield", position: "Engineer", biography: "Ethan's Biography", imageName: nil) // No image for Ethan
    ]
    
    @State private var selectedMember: TeamMember? = nil

    var body: some View {
        VStack(spacing: 20) {
            // Iterating through rows
            ForEach(0..<3) { row in
                HStack(spacing: 20) {
                    // Iterating through columns
                    ForEach(0..<2) { column in
                        if let index = self.indexFor(row: row, column: column) {
                            // Displaying team member view
                            TeamMemberView(member: self.teamMembers[index])
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

/// A view that displays an individual team member.
///
/// `TeamMemberView` shows the team member's picture or a default silhouette, name, and position.
///
/// - Parameters:
///   - member: The team member to be displayed.
struct TeamMemberView: View {
    let member: TeamMember

    var body: some View {
        VStack {
            // Display team member's picture or silhouette
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
            
            // Displaying team member's name and position
            Text(member.name)
                .font(.headline)
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

/// A view that displays the biography of a team member.
///
/// `BiographyView` shows the team member's picture or a default silhouette, name, position, and biography.
///
/// - Parameters:
///   - member: The team member whose biography is displayed.
struct BiographyView: View {
    let member: TeamMember

    var body: some View {
        VStack {
            // Display team member's picture or silhouette
            if let imageName = member.imageName, let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .clipShape(Circle())
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 20)
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .clipShape(Circle())
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 20)
            }

            Text(member.name)
                .font(.largeTitle)
                .padding(.bottom, 5)
            Text(member.position)
                .font(.title)
                .foregroundColor(.secondary)
                .padding(.bottom, 20)
            Text(member.biography)
                .font(.body)
                .padding()
            Spacer()
        }
        .padding()
        .padding(.top, 20)
        .background(Color(UIColor.systemBackground))
    }
}

// Preview Provider for the TeamView
#Preview {
    TeamView()
}
