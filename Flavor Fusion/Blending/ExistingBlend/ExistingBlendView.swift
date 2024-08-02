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
    /// The currently selected recipe.
    @State private var selectedRecipe: Recipe?
    
    /// A flag indicating whether the recipe details popover is presented.
    @State private var isRecipeDetailsPresented = false
    
    /// The store object that manages the list of recipes.
    @ObservedObject var recipeStore = RecipeStore()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    // Display each recipe in a VStack
                    ForEach(recipeStore.recipes) { recipe in
                        ExistingRecipesRows(recipe: recipe)
                            .onTapGesture {
                                // Set the selected recipe when a recipe is tapped
                                self.selectedRecipe = recipe
                                self.isRecipeDetailsPresented = true
                            }
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationBarTitle("Select Recipe", displayMode: .inline)
            .popover(isPresented: $isRecipeDetailsPresented) {
                if let recipe = selectedRecipe {
                    RecipeDetails(recipe: recipe, isPresented: $isRecipeDetailsPresented)
                }
            }
        }
    }
}

/// A view that displays the details of a selected recipe.
///
/// `RecipeDetails` shows the name and servings of the selected recipe.
/// It also includes a button to send the recipe to an Arduino device.
///
/// - Parameters:
///   - recipe: The selected recipe.
///   - isPresented: A binding to control whether the popover is presented.
struct RecipeDetails: View {
    var recipe: Recipe
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Spacer()
                Button(action: {
                    // Dismiss the popover
                    self.isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                }
                .padding()
            }
            
            Text("Selected Recipe:")
                .font(.headline)
            
            Text("Name: \(recipe.name)")
            Text("Servings: \(recipe.servings)")
            
            Spacer()
            
            // Button to send the selected recipe to Arduino (replace with actual action)
            Button(action: {
                // Implement the action to send the selected recipe to Arduino
                print("Sending \(recipe.name) to Arduino...")
                // Dismiss the popover
                self.isPresented = false
            }) {
                Text("Mix Recipe!")
                    .foregroundColor(.primary)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    ExistingBlendView(recipeStore: RecipeStore())
}
