//
//  ExistingBlendView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 5/11/24.
//

import SwiftUI

/// A view that displays a list of existing recipes and allows the user to select one.
///
/// `ExistingBlendView` provides a scrollable list of recipes. When a recipe is tapped,
/// it presents a detailed view of the selected recipe in a popover.
///
/// - Parameters:
///   - recipeStore: An observed object that manages the list of recipes.
struct ExistingBlendView: View {
    @State private var selectedRecipe: Recipe?
    @State private var isRecipeDetailsPresented = false

    @ObservedObject var recipeStore = RecipeStore()
    @ObservedObject var spiceDataViewModel: SpiceDataViewModel
    @EnvironmentObject var bleManager: BLEManager

    // Combine default and user-added recipes
    var combinedRecipes: [Recipe] {
        RecipeStore.defaultRecipes + recipeStore.recipes
    }

    var body: some View {
        NavigationView {
            VStack {
                // Warning message when the tray is not empty
                if !bleManager.isTrayEmpty {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                        Text("Warning: The tray is not empty")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    .padding()
                }
                
                ScrollView {
                    // Display each recipe in a single list
                    ForEach(combinedRecipes) { recipe in
                        ExistingRecipesRows(recipe: recipe, spiceDataViewModel: spiceDataViewModel)
                            .onTapGesture {
                                self.selectedRecipe = recipe
                                self.isRecipeDetailsPresented = true
                            }
                    }
                }
                .padding()
                
                Spacer()
            }
            .sheet(isPresented: $isRecipeDetailsPresented) {
                if let selectedRecipe = selectedRecipe {
                    MixRecipePreview(recipe: selectedRecipe, isPresented: $isRecipeDetailsPresented, spiceDataViewModel: spiceDataViewModel)
                }
            }
        }
    }
}
