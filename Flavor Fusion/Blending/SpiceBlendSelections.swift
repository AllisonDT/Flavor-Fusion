//
//  SpiceBlendSelections.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 3/30/24.
//

import SwiftUI

/// A view that displays a spice blend selection button.
///
/// The `SpiceBlendSelections` view presents a button for a spice blend,
/// allowing users to select or deselect the spice. The appearance of the
/// button changes based on the selection state of the spice.
struct SpiceBlendSelections: View {
    /// The spice data model.
    let spice: Spice

    /// A flag indicating whether the spice is being selected.
    let isSelecting: Bool

    /// A closure called when the selection state changes.
    /// - Parameter isSelected: A boolean indicating the new selection state.
    let onSelect: (Bool) -> Void

    var body: some View {
        Button(action: {
            onSelect(!spice.isSelected)
        }) {
            Text(spice.name)
                .font(.headline)
                .foregroundColor(spice.isSelected ? .blue : .black)
                .padding(40) 
                .frame(maxWidth: .infinity)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.blue.opacity(0.1))
        )
    }
}
