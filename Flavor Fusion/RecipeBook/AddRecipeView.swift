//
//  AddRecipeView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 7/20/24.
//

import SwiftUI

/// A view for creating a new recipe.
///
/// `AddRecipeView` allows users to enter a recipe name, select servings, and choose spices
/// for the recipe. It validates the input and adds the new recipe to the `RecipeStore`.
///
/// - Parameters:
///   - isPresented: A binding to control the presentation of the view.
///   - recipeStore: An observed object that manages the collection of recipes.
struct AddRecipeView: View {
    @Binding var isPresented: Bool
    @ObservedObject var recipeStore: RecipeStore

    @State private var recipeName: String = ""
    @State private var servings = 1
    @State private var spicesData = spiceData
    @State private var selectedSpices: [Spice: (Double, String)] = [:] // Updated to Double
    @State private var showAlert = false
    @State private var alertMessage = ""

    let servingOptions = Array(1...10)
    let unitOptions = ["t", "T"] // "t" for teaspoons, "T" for tablespoons

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    TextField("Recipe Name", text: $recipeName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    HStack {
                        Text("Servings:")
                        Picker(selection: $servings, label: Text("Servings")) {
                            ForEach(servingOptions, id: \.self) { option in
                                Text("\(option)")
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal)
                    }

                    ScrollView {
                        HStack(alignment: .top) {
                            // First column
                            VStack {
                                ForEach(spicesData.indices.filter { $0 < spicesData.count / 2 }, id: \.self) { index in
                                    AddRecipeSpiceView(spice: $spicesData[index], selectedSpices: $selectedSpices, unitOptions: unitOptions)
                                }
                            }
                            // Second column
                            VStack {
                                ForEach(spicesData.indices.filter { $0 >= spicesData.count / 2 }, id: \.self) { index in
                                    AddRecipeSpiceView(spice: $spicesData[index], selectedSpices: $selectedSpices, unitOptions: unitOptions)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                VStack {
                    Spacer()
                    Button(action: {
                        if recipeName.isEmpty {
                            alertMessage = "Please enter a recipe name."
                            showAlert = true
                            return
                        }

                        if recipeStore.recipes.contains(where: { $0.name.lowercased() == recipeName.lowercased() }) {
                            alertMessage = "A recipe with this name already exists."
                            showAlert = true
                            return
                        }

                        if selectedSpices.isEmpty {
                            alertMessage = "Please select at least one spice."
                            showAlert = true
                            return
                        }

                        let ingredients = selectedSpices.map { (spice, amountAndUnit) in
                            Ingredient(
                                name: spice.name,
                                amount: amountAndUnit.0,
                                unit: amountAndUnit.1,
                                containerNumber: spice.containerNumber // Pass the container number here
                            )
                        }
                        let newRecipe = Recipe(
                            name: recipeName,
                            ingredients: ingredients,
                            servings: servings
                        )
                        recipeStore.addRecipe(newRecipe)
                        isPresented = false
                    }) {
                        Text("SAVE")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
            }
            .navigationBarTitle("Create Recipe", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.primary)
            })
        }
    }
}

#Preview {
    AddRecipeView(isPresented: .constant(false), recipeStore: RecipeStore())
}
