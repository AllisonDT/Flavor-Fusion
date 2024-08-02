//
//  RecipeModel.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 3/24/24.
//

import Foundation

/// A struct representing an ingredient in a recipe.
///
/// `Ingredient` conforms to `Codable` to support encoding and decoding.
/// It contains the name and amount of the ingredient.
struct Ingredient: Codable {
    let name: String
    let amount: Double
}

/// A struct representing a recipe.
///
/// `Recipe` conforms to `Identifiable` and `Codable` to support unique identification
/// and encoding/decoding. It contains the recipe's ID, name, ingredients, and servings.
///
/// - Parameters:
///   - id: The unique identifier for the recipe.
///   - name: The name of the recipe.
///   - ingredients: A list of ingredients required for the recipe.
///   - servings: The number of servings the recipe makes.
struct Recipe: Identifiable, Codable {
    let id: UUID
    let name: String
    let ingredients: [Ingredient]
    let servings: Int
    
    /// Initializes a new recipe with the provided name, ingredients, and servings.
    ///
    /// - Parameters:
    ///   - name: The name of the recipe.
    ///   - ingredients: A list of ingredients required for the recipe.
    ///   - servings: The number of servings the recipe makes.
    init(name: String, ingredients: [Ingredient], servings: Int) {
        self.id = UUID()
        self.name = name
        self.ingredients = ingredients
        self.servings = servings
    }
}
