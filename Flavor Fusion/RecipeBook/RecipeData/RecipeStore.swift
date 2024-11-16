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
    @Published var recipes: [Recipe] = []
    private let iCloudStore = NSUbiquitousKeyValueStore.default
    private let userDefaultsKey = "recipes"
    
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

    func removeRecipe(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes.remove(at: index)
            saveRecipes()
        }
    }
    
    /// Updates an existing recipe in the store
    func updateRecipe(_ updatedRecipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == updatedRecipe.id }) {
            recipes[index] = updatedRecipe
            saveRecipes() // Persist the changes
        }
    }
    
    // Save recipes to both UserDefaults and iCloud
    private func saveRecipes() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(recipes) {
            // Save to UserDefaults
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            print("Recipes saved successfully to UserDefaults.")
            
            // Save to iCloud
            iCloudStore.set(encoded, forKey: userDefaultsKey)
            iCloudStore.synchronize()
            print("Recipes saved successfully to iCloud.")
        } else {
            print("Failed to encode and save recipes.")
        }
    }
    
    // Load recipes from UserDefaults first, then iCloud if not available
    private func loadRecipes() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Recipe].self, from: data) {
                recipes = decoded
                print("Recipes loaded from UserDefaults: \(recipes)")
                return
            }
        }
        print("No saved recipes found in UserDefaults. Attempting to load from iCloud.")
        loadRecipesFromiCloud()
    }
    
    // Load recipes from iCloud
    private func loadRecipesFromiCloud() {
        if let data = iCloudStore.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Recipe].self, from: data) {
            recipes = decoded
            print("Recipes loaded from iCloud: \(recipes)")
            // Save to UserDefaults for local persistence
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } else {
            print("No saved recipes found in iCloud.")
        }
    }
}
