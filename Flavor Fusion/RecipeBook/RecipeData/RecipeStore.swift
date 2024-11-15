//
//  RecipeStore.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 3/24/24.
//

import Foundation
import CloudKit

/// A class that manages a collection of recipes.
///
/// `RecipeStore` conforms to `ObservableObject` to support SwiftUI data binding.
/// It provides functions to add, remove, load, and save recipes.
class RecipeStore: ObservableObject {
    @Published var recipes: [Recipe] = []  // Only for user-added recipes
    private let iCloudStore = NSUbiquitousKeyValueStore.default
    private let userDefaultsKey = "userRecipes"
    
    // Default recipes constant (not saved to UserDefaults or iCloud)
    static let defaultRecipes: [Recipe] = [
        Recipe(
            name: "Spicy BBQ Rub",
            ingredients: [
                Ingredient(name: "Paprika", amount: 2, unit: "T"),
                Ingredient(name: "Brown Sugar", amount: 2, unit: "T"),
                Ingredient(name: "Salt", amount: 1, unit: "t"),
                Ingredient(name: "Pepper", amount: 1, unit: "t")
            ],
            servings: 4
        ),
        Recipe(
            name: "Italian Herb Mix",
            ingredients: [
                Ingredient(name: "Basil", amount: 1, unit: "T"),
                Ingredient(name: "Oregano", amount: 1, unit: "T"),
                Ingredient(name: "Thyme", amount: 1, unit: "t"),
                Ingredient(name: "Rosemary", amount: 1, unit: "t")
            ],
            servings: 3
        ),
        Recipe(
            name: "Curry Powder",
            ingredients: [
                Ingredient(name: "Turmeric", amount: 2, unit: "t"),
                Ingredient(name: "Cumin", amount: 1, unit: "t"),
                Ingredient(name: "Coriander", amount: 1, unit: "t"),
                Ingredient(name: "Cardamom", amount: 0.5, unit: "t")
            ],
            servings: 6
        ),
        Recipe(
            name: "Pumpkin Pie Spice",
            ingredients: [
                Ingredient(name: "Cinnamon", amount: 2, unit: "T"),
                Ingredient(name: "Ginger", amount: 1, unit: "t"),
                Ingredient(name: "Nutmeg", amount: 1, unit: "t"),
                Ingredient(name: "Allspice", amount: 0.5, unit: "t"),
                Ingredient(name: "Cloves", amount: 0.5, unit: "t")
            ],
            servings: 4
        ),
        Recipe(
            name: "Taco Seasoning",
            ingredients: [
                Ingredient(name: "Chili Powder", amount: 1, unit: "T"),
                Ingredient(name: "Cumin", amount: 1, unit: "t"),
                Ingredient(name: "Paprika", amount: 1, unit: "t"),
                Ingredient(name: "Garlic Powder", amount: 1, unit: "t"),
                Ingredient(name: "Onion Powder", amount: 0.5, unit: "t"),
                Ingredient(name: "Oregano", amount: 0.5, unit: "t"),
                Ingredient(name: "Salt", amount: 0.5, unit: "t"),
                Ingredient(name: "Black Pepper", amount: 0.25, unit: "t")
            ],
            servings: 4
        )
    ]
    
    init() {
        self.loadRecipes()
        NotificationCenter.default.addObserver(self, selector: #selector(icloudStoreDidChange), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: iCloudStore)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func icloudStoreDidChange(notification: NSNotification) {
        self.loadRecipesFromiCloud()
    }

    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
        saveRecipes()
    }
    
    func updateRecipe(_ updatedRecipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == updatedRecipe.id }) {
            recipes[index] = updatedRecipe
            saveRecipes()
        }
    }

    func removeRecipe(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes.remove(at: index)
            saveRecipes()
        }
    }

    // Save only user-added recipes to UserDefaults and iCloud
    private func saveRecipes() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(recipes) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            iCloudStore.set(encoded, forKey: userDefaultsKey)
            iCloudStore.synchronize()
        }
    }

    private func loadRecipes() {
        // Load only user-added recipes
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Recipe].self, from: data) {
                recipes = decoded
                return
            }
        }
        loadRecipesFromiCloud()
    }

    private func loadRecipesFromiCloud() {
        if let data = iCloudStore.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Recipe].self, from: data) {
            recipes = decoded
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}
