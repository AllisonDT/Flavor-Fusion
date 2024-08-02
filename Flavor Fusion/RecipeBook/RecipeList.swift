//
//  SearchBar.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 7/20/24.
//

import SwiftUI

/// A search bar view for filtering recipes.
///
/// `SearchBar` is a `UIViewRepresentable` that integrates a `UISearchBar` into SwiftUI.
/// It updates the search text as the user types.
struct SearchBar: UIViewRepresentable {
    @Binding var searchText: String

    /// Coordinator class to handle `UISearchBar` delegate methods.
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var searchText: String

        init(searchText: Binding<String>) {
            _searchText = searchText
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.searchText = searchText
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(searchText: $searchText)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search Recipes"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = searchText
    }
}

/// A view that displays a list of recipes with search and add functionality.
///
/// `RecipeList` shows a searchable list of recipes and a button to add new recipes.
/// It filters recipes based on the search text.
struct RecipeList: View {
    @ObservedObject var recipeStore = RecipeStore()
    
    @State private var searchText: String = ""
    @State private var isAddRecipeViewPresented = false
    
    /// Filters the recipes based on the search text.
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipeStore.recipes
        } else {
            return recipeStore.recipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    SearchBar(searchText: $searchText)
                    Spacer()
                    Button(action: {
                        isAddRecipeViewPresented.toggle()
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 24))
                            .padding()
                            .foregroundColor(.blue)
                    }
                }
                .padding([.leading, .trailing, .top])
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredRecipes) { recipe in
                            RecipeRow(recipe: recipe, recipeStore: recipeStore)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("Recipes", displayMode: .inline)
        }
        .sheet(isPresented: $isAddRecipeViewPresented) {
            AddRecipeView(isPresented: $isAddRecipeViewPresented, recipeStore: recipeStore)
        }
    }
}

/// A button view for filters functionality.
///
/// `FiltersButton` displays a button that can be used to apply filters.
struct FiltersButton: View {
    var body: some View {
        Button(action: {
            // Action for Filters Button
        }) {
            Image(systemName: "line.horizontal.3.decrease.circle")
                .font(.system(size: 24))
                .padding()
                .foregroundColor(.blue)
        }
    }
}

/// A view that displays a row representing a recipe.
///
/// `RecipeRow` shows the recipe's name, servings, and provides options to preview or delete the recipe.
struct RecipeRow: View {
    var recipe: Recipe
    var recipeStore: RecipeStore
    @State private var isMixPreviewPresented = false
    @State private var isDeleteAlertPresented = false

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
                isDeleteAlertPresented = true
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .padding()
            .alert(isPresented: $isDeleteAlertPresented) {
                Alert(
                    title: Text("Delete Recipe"),
                    message: Text("Are you sure you want to delete this recipe?"),
                    primaryButton: .destructive(Text("Delete")) {
                        recipeStore.removeRecipe(recipe)
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .gray, radius: 2, x: 0, y: 2)
        )
        .padding(.vertical, 4)
    }
}

// Preview Provider for the RecipeList
#Preview {
    RecipeList()
}
