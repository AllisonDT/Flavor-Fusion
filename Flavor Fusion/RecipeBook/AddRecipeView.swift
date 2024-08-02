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
    @State private var selectedSpices: [Spice: Int] = [:]
    @State private var showAlert = false
    @State private var alertMessage = ""

    let servingOptions = Array(1...10)

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
                                    AddRecipeSpiceView(spice: $spicesData[index], selectedSpices: $selectedSpices)
                                }
                            }
                            // Second column
                            VStack {
                                ForEach(spicesData.indices.filter { $0 >= spicesData.count / 2 }, id: \.self) { index in
                                    AddRecipeSpiceView(spice: $spicesData[index], selectedSpices: $selectedSpices)
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

                        if selectedSpices.isEmpty {
                            alertMessage = "Please select at least one spice."
                            showAlert = true
                            return
                        }

                        let ingredients = selectedSpices.map { Ingredient(name: $0.key.name, amount: Double($0.value)) }
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

/// A view that displays a spice row with selection capability for adding to a recipe.
///
/// `AddRecipeSpiceView` allows users to select a spice and specify the amount for the recipe.
///
/// - Parameters:
///   - spice: A binding to the spice to display in the row.
///   - selectedSpices: A binding to a dictionary of selected spices and their amounts.
struct AddRecipeSpiceView: View {
    @Binding var spice: Spice
    @Binding var selectedSpices: [Spice: Int]

    let spiceQuantities = Array(1...10)

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    if self.selectedSpices.keys.contains(spice) {
                        self.selectedSpices.removeValue(forKey: spice)
                    } else {
                        self.selectedSpices[spice] = 1
                    }
                }) {
                    Image(systemName: self.selectedSpices.keys.contains(spice) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(self.selectedSpices.keys.contains(spice) ? .green : .gray)
                }
                .buttonStyle(PlainButtonStyle())

                Text(spice.name)
                    .foregroundColor(.primary)
                    .font(.body)

                Spacer()
            }

            if self.selectedSpices.keys.contains(spice) {
                HStack {
                    Text("Amount")
                        .foregroundColor(.primary)
                        .font(.body)

                    Picker("Quantity", selection: Binding(
                        get: { self.selectedSpices[spice] ?? 1 },
                        set: { self.selectedSpices[spice] = $0 }
                    )) {
                        ForEach(spiceQuantities, id: \.self) { quantity in
                            Text("\(quantity)")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 70)
                }
                .padding(.top, 5)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .gray, radius: 2, x: 0, y: 2)
        )
        .padding(.vertical, 5)
    }
}

// Preview Provider for the AddRecipeView
#Preview {
    AddRecipeView(isPresented: .constant(false), recipeStore: RecipeStore())
}
