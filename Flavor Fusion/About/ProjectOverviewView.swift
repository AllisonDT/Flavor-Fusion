//
//  ProjectOverviewView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 4/6/24.
//

import SwiftUI

struct ProjectOverviewView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Flavor Fusion: An Interdisciplinary Senior Design Project")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Spacer()
            
            Text("The objective of Flavor Fusion is to develop and create a spice dispenser for at home and commercial use cases. This device aims at tackling different problems that many foodies, especially budding foodies, run into. One of them is food waste: food waste along with any kind of waste is a huge problem the modern world faces every day, and our product is designed to reduce the overuse and waste of these ingredients by allowing the user to control and adapt recipes or blends however they seem fit. This device is inspired by cereal dispensers and 3D printers where the device will allow refillable spice cartridges to dispense a specified amount of spice that is controlled by the user. The device will have an LCD display and control features that will allow the user to see where certain spices are located, recipes, as well as a progress bar. The device will also allow the user to manually control the amount of spice if they so choose. Flavor Fusion will have a mobile app as well where the user can connect wirelessly to the machine to upload custom blends and see recipes they have created. The app will also turn on the machine and allow users to upload jobs to the machine.  ")
                .font(.body)
                .foregroundColor(.black)
        }
        .padding()
    }
}

#Preview {
    ProjectOverviewView()
}
