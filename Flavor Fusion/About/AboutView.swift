//
//  AboutView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 3/24/24.
//

import SwiftUI

/// A view that provides information about the Flavor Fusion app.
///
/// `AboutView` displays navigation links to various sections such as Project Overview,
/// User Manual, Privacy Information, and Meet the Team. It also includes an icon
/// at the bottom of the view.
struct AboutView: View {
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 15) {
                    NavigationLink(destination: ProjectOverviewView()) {
                        CustomListItem(title: "Project Overview")
                    }
                    NavigationLink(destination: UserManualView()) {
                        CustomListItem(title: "User Manual")
                    }
                    NavigationLink(destination: PrivacyInfoView()) {
                        CustomListItem(title: "Privacy Information")
                    }
                    NavigationLink(destination: TeamView()) {
                        CustomListItem(title: "Meet the Team")
                    }
                }
                .padding(.horizontal)
                Spacer()
                
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.blue.opacity(0.5))
                    .padding(.bottom, 20)
                
            }
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationBarTitle("About Flavor Fusion", displayMode: .inline)
        }
    }
}

/// A custom list item view used in the AboutView.
///
/// `CustomListItem` displays a title and a chevron icon, and is used for navigation links in the AboutView.
///
/// - Parameters:
///   - title: The title of the list item.
struct CustomListItem: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.primary) // Ensure the text color is set
                .padding(.horizontal)
                .padding(.vertical, 15)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(.trailing)
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 2, x: 0, y: 2)
        .padding(.vertical, 4)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
