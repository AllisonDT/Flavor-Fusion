//
//  List.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 3/24/24.
//

import SwiftUI

/// A view that displays a list of spices and provides options for blending.
///
/// `List` displays a list of spices in two columns and includes buttons for blending.
/// Tapping on a spice presents a detailed view in a popup. The blending process
/// can be initiated from the main view.
struct List: View {
    @State private var isSelecting: Bool = false
    @State private var isBlendPopupVisible: Bool = false
    @State private var isSpicePopupVisible: Bool = false
    @State private var selectedSpice: Spice?
    @ObservedObject var recipeStore = RecipeStore()
    @State private var displayName: String = UserDefaults.standard.string(forKey: "displayName") ?? "Flavor Fusion"

    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    isBlendPopupVisible.toggle()
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
                
                HStack {
                    VStack {
                        ForEach(firstColumnSpices) { spice in
                            SpiceRow(spice: spice, isSelecting: isSelecting, recipes: recipeStore.recipes) { selected in
                                if let index = spiceData.firstIndex(where: { $0.id == spice.id }) {
                                    spiceData[index].isSelected = selected
                                }
                            }
                            .onTapGesture {
                                selectedSpice = spice
                                isSpicePopupVisible = true
                            }
                        }
                    }
                    
                    VStack {
                        ForEach(secondColumnSpices) { spice in
                            SpiceRow(spice: spice, isSelecting: isSelecting, recipes: recipeStore.recipes) { selected in
                                if let index = spiceData.firstIndex(where: { $0.id == spice.id }) {
                                    spiceData[index].isSelected = selected
                                }
                            }
                            .onTapGesture {
                                selectedSpice = spice
                                isSpicePopupVisible = true
                            }
                        }
                    }
                }
                .padding()
            }
            .sheet(isPresented: $isBlendPopupVisible) {
                BlendingNewExistingView(isPresented: $isBlendPopupVisible)
            }
            .sheet(isPresented: $isSpicePopupVisible) {
                if let selectedSpice = selectedSpice {
                    SpicePopupView(spice: selectedSpice, recipes: recipeStore.recipes, isPresented: $isSpicePopupVisible)
                }
            }
            .navigationBarTitle("\(displayName)'s Cabinet", displayMode: .inline)
        }
    }
}

struct List_Previews: PreviewProvider {
    static var previews: some View {
        List()
    }
}
