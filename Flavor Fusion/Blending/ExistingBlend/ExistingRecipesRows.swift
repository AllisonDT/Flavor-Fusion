//
//  ExistingRecipesRows.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 7/20/24.
//

import SwiftUI

/// A view that displays a row representing an existing recipe.
///
/// `ExistingRecipesRows` shows the recipe name and servings. It includes a button
/// to present a preview of the recipe mix in a sheet.
///
/// - Parameters:
///   - recipe: The recipe to be displayed in the row.
struct ExistingRecipesRows: View {
    /// The recipe to be displayed in the row.
    var recipe: Recipe
    
    /// A flag indicating whether the mix preview sheet is presented.
    @State private var isMixPreviewPresented = false

    var body: some View {
        Button(action: {
            isMixPreviewPresented.toggle()
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    Text("Servings: \(recipe.servings)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                
                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
            )
            .padding(.vertical, 4)
            .padding(.horizontal, 4)  // Add padding to the edges
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .sheet(isPresented: $isMixPreviewPresented) {
            MixRecipePreview(recipe: recipe, isPresented: $isMixPreviewPresented)
        }
        .buttonStyle(PlainButtonStyle())  // Ensure the button does not change the visual style
    }
}
