//
//  MixRecipePreview.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 7/1/24.
//

import SwiftUI

/// A view that provides a preview of a recipe with options to adjust servings and start the blending process.
///
/// `MixRecipePreview` shows the recipe details, allows users to adjust the number of servings, and initiate the blending process.
///
/// - Parameters:
///   - recipe: The recipe to preview.
///   - isPresented: A binding to control the presentation of the view.
struct MixRecipePreview: View {
    var recipe: Recipe
    @Binding var isPresented: Bool
    @State private var isBlendConfirmationViewPresented: Bool = false
    @State private var showBlending: Bool = false
    @State private var showCompletion: Bool = false
    @State private var selectedServings: Int

    /// Initializes a new `MixRecipePreview` instance.
    ///
    /// - Parameters:
    ///   - recipe: The recipe to preview.
    ///   - isPresented: A binding to control the presentation of the view.
    init(recipe: Recipe, isPresented: Binding<Bool>) {
        self.recipe = recipe
        self._isPresented = isPresented
        self._selectedServings = State(initialValue: recipe.servings)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(recipe.name)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.primary)
                        .padding(.top)
                    
                    HStack {
                        Text("Servings")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.secondary)
                        Spacer()
                        Picker("Servings", selection: $selectedServings) {
                            ForEach(1..<21, id: \.self) { serving in
                                Text("\(serving)").tag(serving)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    Text("Ingredients:")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.primary)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(recipe.ingredients, id: \.name) { ingredient in
                            let amount = ingredient.amount * Double(selectedServings) / Double(recipe.servings)
                            HStack {
                                Text(ingredient.name)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\(amount, specifier: "%.2f")")
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            isBlendConfirmationViewPresented.toggle()
                        }) {
                            Text("BLEND")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .sheet(isPresented: $isBlendConfirmationViewPresented) {
                BlendConfirmationView(
                    spiceName: recipe.name,
                    servings: selectedServings,
                    ingredients: recipe.ingredients.map { $0.name },
                    onConfirm: {
                        isBlendConfirmationViewPresented = false
                        showBlending = true
                    }
                )
            }
            .sheet(isPresented: $showBlending) {
                BlendingView(onComplete: {
                    showBlending = false
                    showCompletion = true
                })
            }
            .sheet(isPresented: $showCompletion) {
                BlendCompletionView(onDone: {
                    showCompletion = false
                    isPresented = false
                })
            }
            .navigationBarTitle("Recipe Preview", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.primary)
            })
        }
    }
}

// Preview Provider for the MixRecipePreview
#Preview {
    MixRecipePreview(recipe: Recipe(name: "Sample Recipe", ingredients: [Ingredient(name: "Spice 1", amount: 1)], servings: 2), isPresented: .constant(true))
}
