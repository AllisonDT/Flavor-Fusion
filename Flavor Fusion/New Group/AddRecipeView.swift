//
//  AddRecipeView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 2/21/24.
//

import SwiftUI

struct AddRecipeView: View {
    @Binding var isPresented: Bool
    @Binding var recipes: [SpiceMixRecipe]
    
    @State private var recipeName = ""
    @State private var ingredients = ""
    @State private var instructions = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Recipe Name", text: $recipeName)
                    TextField("Ingredients", text: $ingredients)
                    TextField("Instructions", text: $instructions)
                }
                
                Section {
                    Button("Add Recipe") {
                        // Validate and add the recipe
                        let ingredientList = ingredients.components(separatedBy: ",")
                        let newRecipe = SpiceMixRecipe(name: recipeName, ingredients: ingredientList, instructions: instructions)
                        recipes.append(newRecipe)
                        isPresented = false // Dismiss the sheet
                    }
                }
            }
            .navigationTitle("Add Recipe")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false // Dismiss the sheet
            })
        }
    }
}


#Preview {
    AddRecipeView()
}
