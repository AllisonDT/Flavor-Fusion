//
//  BlendingNewExistingView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 7/13/24.
//

import SwiftUI

/// A view that allows the user to choose between creating a new blend or selecting an existing one.
///
/// `BlendingNewExistingView` provides a segmented control to switch between creating a new blend
/// and selecting an existing blend. The appropriate view is displayed based on the user's selection.
///
/// - Parameters:
///   - isPresented: A binding to control whether the view is presented.
struct BlendingNewExistingView: View {
    @Environment(\.presentationMode) var presentationMode
    
    /// A flag indicating whether the new blend popup is visible.
    @State private var isNewBlendPopupVisible = false
    
    /// The selected option: 0 for New, 1 for Existing.
    @State private var selectedOption = 0
    
    /// A binding to control whether the view is presented.
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                // Segmented control for selecting new or existing
                Picker(selection: $selectedOption, label: Text("")) {
                    Text("New").tag(0)
                    Text("Existing").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Display content based on selection
                if selectedOption == 0 {
                    NewBlendView()
                } else {
                    ExistingBlendView()
                }
            }
            .navigationBarTitle("Blend", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.primary)
            })
        }
    }
}

struct BlendingNewExistingView_Previews: PreviewProvider {
    @State static var isPresented = true
    
    static var previews: some View {
        BlendingNewExistingView(isPresented: $isPresented)
    }
}
