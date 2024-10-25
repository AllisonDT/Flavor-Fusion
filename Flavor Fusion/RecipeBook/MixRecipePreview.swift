//
//  MixRecipePreview.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 7/1/24.
//

import SwiftUI

/// A view that provides a detailed preview of a recipe, with options to adjust servings and initiate the blending process.
///
/// `MixRecipePreview` displays the recipe name, servings, and ingredients, allowing users to modify the number of servings. It also offers the option to start the blending process, leading through confirmation, blending, and completion steps.
///
/// - Parameters:
///   - recipe: The recipe to be previewed.
///   - isPresented: A binding to control the visibility of the view.
///   - spiceDataViewModel: An observed object that manages spice data and is used throughout the blending process.
struct MixRecipePreview: View {
    var recipe: Recipe
    @Binding var isPresented: Bool
    @State private var isBlendConfirmationViewPresented: Bool = false
    @State private var showBlending: Bool = false
    @State private var showCompletion: Bool = false
    @State private var selectedServings: Int
    @ObservedObject var spiceDataViewModel: SpiceDataViewModel

    init(recipe: Recipe, isPresented: Binding<Bool>, spiceDataViewModel: SpiceDataViewModel) {
        self.recipe = recipe
        self._isPresented = isPresented
        self._selectedServings = State(initialValue: recipe.servings)
        self.spiceDataViewModel = spiceDataViewModel
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
                                Text("\(formatAmount(amount: amount, unit: ingredient.unit))")
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
                    ingredients: recipe.ingredients.map { ingredient in
                        Ingredient(
                            name: ingredient.name,
                            amount: ingredient.amount * Double(selectedServings) / Double(recipe.servings),
                            unit: ingredient.unit,
                            containerNumber: ingredient.containerNumber
                        )
                    },
                    onConfirm: {
                        isBlendConfirmationViewPresented = false
                        showBlending = true
                    },
                    spiceDataViewModel: spiceDataViewModel
                )
                .environmentObject(spiceDataViewModel)
            }
            .sheet(isPresented: $showBlending) {
                BlendingView(
                    spiceName: recipe.name,
                    servings: selectedServings,
                    ingredients: recipe.ingredients,
                    onComplete: {
                        showBlending = false
                        showCompletion = true
                    }
                )
                .environmentObject(spiceDataViewModel)
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
    
    private func formatAmount(amount: Double, unit: String) -> String {
        let fraction = convertToFraction(amount: amount)
        return "\(fraction) \(unit == "t" ? "tsp" : "tbsp")"
    }
    
    private func convertToFraction(amount: Double) -> String {
        let tolerance = 1.0 / 64.0
        let number = amount
        var lowerNumerator = 0
        var lowerDenominator = 1
        var upperNumerator = 1
        var upperDenominator = 0
        var middleNumerator = 1
        var middleDenominator = 1
        
        while true {
            let middle = Double(middleNumerator) / Double(middleDenominator)
            if abs(middle - number) < tolerance {
                break
            } else if middle < number {
                lowerNumerator = middleNumerator
                lowerDenominator = middleDenominator
            } else {
                upperNumerator = middleNumerator
                upperDenominator = middleDenominator
            }
            middleNumerator = lowerNumerator + upperNumerator
            middleDenominator = lowerDenominator + upperDenominator
        }

        let wholeNumber = Int(amount)
        let remainderNumerator = middleNumerator - wholeNumber * middleDenominator

        if wholeNumber > 0 {
            return remainderNumerator > 0 ? "\(wholeNumber) \(remainderNumerator)/\(middleDenominator)" : "\(wholeNumber)"
        } else {
            return "\(middleNumerator)/\(middleDenominator)"
        }
    }
}


// Preview Provider for the MixRecipePreview
#Preview {
    MixRecipePreview(
        recipe: Recipe(
            name: "Sample Recipe",
            ingredients: [
                Ingredient(name: "Spice 1", amount: 1, unit: "T", containerNumber: 2)
            ],
            servings: 2
        ),
        isPresented: .constant(true),
        spiceDataViewModel: SpiceDataViewModel() // Pass an instance of SpiceDataViewModel
    )
}
