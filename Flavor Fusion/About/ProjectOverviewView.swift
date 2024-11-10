//
//  ProjectOverviewView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 4/6/24.
//

import SwiftUI

/// A view that provides an overview of the Flavor Fusion project.
///
/// `ProjectOverviewView` displays information about the objectives and features of
/// the Flavor Fusion project, detailing its purpose, design, and functionality.
struct ProjectOverviewView: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Flavor Fusion: An Interdisciplinary Senior Design Project")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("""
                    The objective of Flavor Fusion is to develop and create a spice dispenser for at-home and commercial use cases. This device aims at tackling different problems that many foodies, especially budding foodies, run into. One of them is food waste: food waste along with any kind of waste is a huge problem the modern world faces every day, and our product is designed to reduce the overuse and waste of these ingredients by allowing the user to control and adapt recipes or blends however they see fit. 

                    This device is inspired by cereal dispensers and 3D printers, allowing refillable spice cartridges to dispense a specified amount of spice controlled by the user. The device will feature an LCD display and control panel where users can view spice locations, recipes, and a progress bar. Users can also manually control the spice amount if they choose. Additionally, Flavor Fusion will have a mobile app that lets users connect wirelessly to the machine to upload custom blends, view recipes, turn on the machine, and send jobs to it.
                    """)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding()
                .frame(width: geometry.size.width) // Adjusts to the screen width
            }
        }
    }
}

// Preview Provider for the ProjectOverviewView
#Preview {
    ProjectOverviewView()
}
