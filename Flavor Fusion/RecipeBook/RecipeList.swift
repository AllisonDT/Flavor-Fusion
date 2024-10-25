//
//  SearchBar.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 7/20/24.
//

import SwiftUI

/// A view that displays a list of recipes with search and add functionality.
///
/// `RecipeList` shows a searchable list of recipes and a button to add new recipes.
/// It filters recipes based on the search text.
struct RecipeList: View {
    @ObservedObject var recipeStore = RecipeStore()
    @ObservedObject var spiceDataViewModel: SpiceDataViewModel

    @State private var searchText: String = ""
    @State private var isAddRecipeViewPresented = false

    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipeStore.recipes
        } else {
            return recipeStore.recipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    SearchBar(searchText: $searchText)
                    Spacer()
                    Button(action: {
                        isAddRecipeViewPresented.toggle()
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 24))
                            .padding()
                            .foregroundColor(.blue)
                    }
                }
                .padding([.leading, .trailing, .top])

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredRecipes) { recipe in
                            RecipeRow(recipe: recipe, recipeStore: recipeStore, spiceDataViewModel: spiceDataViewModel)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("Recipes", displayMode: .inline)
        }
        .sheet(isPresented: $isAddRecipeViewPresented) {
            AddRecipeView(isPresented: $isAddRecipeViewPresented, recipeStore: recipeStore)
        }
    }
}
