//
//  SpiceIndicator.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 2/5/24.
//

import SwiftUI

/// A view that displays a circular indicator representing the amount of a spice.
///
/// `SpiceIndicator` shows a circular progress bar and the percentage of the spice amount.
/// The indicator changes color based on the amount and toggles between showing the percentage
/// and the raw value when tapped.
///
/// - Parameters:
///   - amount: The amount of spice as a double between 0 and 1.
///   - isSelected: A boolean indicating if the spice is selected.
struct SpiceIndicator: View {
    var amount: Double
    var isSelected: Bool
    
    @State private var showPercentage: Bool = true

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray, lineWidth: 2)
                .foregroundColor(isSelected ? .green : .clear)
            Circle().trim(from: 0.0, to: CGFloat(amount))
                .stroke(colorForAmount(amount), lineWidth: 4)
                .rotationEffect(Angle(degrees: -90))
            Text(showPercentage ? "\(Int(amount * 100))%" : String(format: "%.2f", amount))
                .font(.system(size: 20))
                .bold()
                .foregroundColor(colorForAmount(amount))
        }
        .frame(width: 90, height: 90)
        .onTapGesture {
            showPercentage.toggle()
        }
    }

    /// Determines the color of the indicator based on the amount.
    ///
    /// - Parameter amount: The amount of spice as a double.
    /// - Returns: A color corresponding to the amount.
    func colorForAmount(_ amount: Double) -> Color {
        switch amount {
        case 0...0.25:
            return .red
        case 0.25...0.5:
            return .orange
        case 0.5...0.75:
            return .yellow
        case 0.75...1.0:
            return .green
        default:
            return .gray
        }
    }
}

// Preview Provider for the SpiceIndicator
#Preview {
    SpiceIndicator(amount: 0.2, isSelected: true)
}
