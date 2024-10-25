//
//  EditRecipeView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 9/25/24.
//

import SwiftUI

/// A view for editing an existing recipe.
///
/// `EditRecipeView` allows users to update the recipe name, number of servings, and spices.
/// It validates the input and updates the recipe in the `RecipeStore`, ensuring no duplicate recipe names
/// and requiring at least one spice to be selected.
///
/// - Parameters:
///   - isPresented: A binding to control the presentation of the view.
///   - recipeStore: An observed object that manages the collection of recipes.
///   - recipe: The recipe to be edited.
///   - recipeName: The name of the recipe being edited.
///   - servings: The number of servings for the recipe.
///   - spicesData: The list of available spices for selection.
///   - selectedSpices: A dictionary of spices selected for the recipe, along with their corresponding amounts and units.
///   - showAlert: A state controlling whether an error alert should be shown.
///   - alertMessage: The message to display when the alert is presented.
struct EditRecipeView: View {
    @Binding var isPresented: Bool
    @ObservedObject var recipeStore: RecipeStore
    @State private var recipe: Recipe

    @State private var recipeName: String
    @State private var servings: Int
    @State private var spicesData = spiceData
    @State private var selectedSpices: [Spice: (Double, String)]
    @State private var showAlert = false
    @State private var alertMessage = ""

    let servingOptions = Array(1...10)
    let unitOptions = ["t", "T"] // "t" for teaspoons, "T" for tablespoons

    init(isPresented: Binding<Bool>, recipeStore: RecipeStore, recipe: Recipe) {
        self._isPresented = isPresented
        self._recipeStore = ObservedObject(initialValue: recipeStore)
        self._recipe = State(initialValue: recipe)
        self._recipeName = State(initialValue: recipe.name)
        self._servings = State(initialValue: recipe.servings)
        let initialSelectedSpices = recipe.ingredients.reduce(into: [Spice: (Double, String)]()) { result, ingredient in
            if let spice = spiceData.first(where: { $0.name == ingredient.name }) {
                result[spice] = (ingredient.amount, ingredient.unit)
            }
        }
        self._selectedSpices = State(initialValue: initialSelectedSpices)
    }

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
                                    EditRecipeSpiceView(spice: $spicesData[index], selectedSpices: $selectedSpices, unitOptions: unitOptions)
                                }
                            }
                            // Second column
                            VStack {
                                ForEach(spicesData.indices.filter { $0 >= spicesData.count / 2 }, id: \.self) { index in
                                    EditRecipeSpiceView(spice: $spicesData[index], selectedSpices: $selectedSpices, unitOptions: unitOptions)
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

                        if recipeStore.recipes.contains(where: { $0.name.lowercased() == recipeName.lowercased() && $0.id != recipe.id }) {
                            alertMessage = "A recipe with this name already exists."
                            showAlert = true
                            return
                        }

                        if selectedSpices.isEmpty {
                            alertMessage = "Please select at least one spice."
                            showAlert = true
                            return
                        }

                        let updatedIngredients = selectedSpices.map { (spice, amountAndUnit) in
                            Ingredient(
                                name: spice.name,
                                amount: amountAndUnit.0,
                                unit: amountAndUnit.1,
                                containerNumber: spice.containerNumber
                            )
                        }
                        recipe.name = recipeName
                        recipe.servings = servings
                        recipe.ingredients = updatedIngredients

                        recipeStore.updateRecipe(recipe)
                        isPresented = false
                    }) {
                        Text("SAVE")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }

                    .padding(.horizontal)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
            }
            .navigationBarTitle("Edit Recipe", displayMode: .inline)
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
    EditRecipeView(isPresented: .constant(false), recipeStore: RecipeStore(), recipe: Recipe(name: "Example Recipe", ingredients: [], servings: 2))
}
