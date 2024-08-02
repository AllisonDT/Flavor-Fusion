//
//  ListTabView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 3/24/24.
//

import SwiftUI

/// A view that provides a tabbed interface for the main sections of the app.
///
/// `ListTabView` displays a tab bar with four tabs: Home, Recipe Book, Settings, and About.
/// Each tab presents a different view when selected.
///
/// - Parameters:
///   - tabSelection: A state variable that tracks the selected tab.
struct ListTabView: View {
    @State private var tabSelection = 0
    
    var body: some View {
        TabView(selection: $tabSelection) {
            List()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
                
            RecipeList()
                .tabItem {
                    Label("Recipe Book", systemImage: "book")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
            
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
                .tag(3)
        }
        .id(tabSelection)
    }
}

#Preview {
    ListTabView()
}
