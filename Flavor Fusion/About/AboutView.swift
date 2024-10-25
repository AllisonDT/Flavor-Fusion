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
import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack(spacing: 10) { // Adjust spacing to match RecipeRow
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
                }
                .padding(.top)
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationBarTitle("About Flavor Fusion", displayMode: .inline)
        }
    }
}

struct CustomListItem: View {
    var title: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline) // Match RecipeRow's font style
                    .foregroundColor(.blue) // Set to blue, consistent with RecipeRow
            }
            .padding()

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .gray, radius: 2, x: 0, y: 2)
        )
        .padding(.vertical, 4)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
