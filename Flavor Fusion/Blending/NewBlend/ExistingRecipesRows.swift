//
//  ExistingRecipesRows.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 7/20/24.
//

import SwiftUI

struct ExistingRecipesRows: View {
    var recipe: Recipe
    var recipeStore: RecipeStore
    @State private var isMixPreviewPresented = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Button(action: {
                    isMixPreviewPresented.toggle()
                }) {
                    Text(recipe.name)
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $isMixPreviewPresented) {
                    MixRecipePreview(recipe: recipe, isPresented: $isMixPreviewPresented)
                }
                
                Text("Servings: \(recipe.servings)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                recipeStore.removeRecipe(recipe)
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: .gray, radius: 2, x: 0, y: 2)
        )
        .padding(.vertical, 4)
    }
}
