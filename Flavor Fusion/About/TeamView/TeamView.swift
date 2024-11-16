//
//  TeamView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 10/8/24.
//

import SwiftUI

/// A view that displays the team members of Flavor Fusion.
///
/// `TeamView` shows a grid of team members with their pictures, names, and positions.
/// Tapping on a team member presents their biography in a modal sheet.
struct TeamView: View {
    /// An array containing the team members, their positions, and biographies.
    let teamMembers = [
        TeamMember(name: "Ryan Latterell", position: "Project Manager", biography: "Ryan was responsible for overseeing all deliverables, including the showcase video, presentations, and documentation. He ensured that each component met quality standards, adhered to the project timeline, and effectively conveyed the project’s objectives, challenges, and successes. Ryan’s role involved constant communication with each team member to monitor progress, identify any roadblocks, and provide solutions to keep the project on track. Additionally, he managed the schedule to align with milestones, making sure everything was ready for final submission and presentation. His organizational skills were essential in bringing together the technical, design, and communication aspects of the project to create the final product", imageName: "ryan"),
        TeamMember(name: "Allison", position: "App Developer", biography: "Allison led the development of the mobile application subsystem, focusing on creating a user-friendly experience with wireless Bluetooth connectivity. Her main objectives were to design an app with a home list of spices, a recipe book, a settings page, and app information, allowing users to view container levels, receive low-spice notifications, and manage recipes and orders. She implemented features such as a login passcode, adjustable text size, light/dark mode, and proper color contrast to meet accessibility requirements. Allison used App Store Connect and Test Flight, enabled by her Apple Developer Program membership, to distribute the app for testing without requiring developer mode on iPhones. Most development time was spent on the recipe book and spice list, with the UI largely completed and Bluetooth connection established from Arduino to iPhone. As work on the physical device progresses, Allison plans to make any necessary UI adjustments and finalize Bluetooth integration alongside Arduino coding. She anticipates potential Bluetooth-related issues, which will be resolved in collaboration with the electronics team.", imageName: "allison"),
        TeamMember(name: "Samuel Pabon", position: "Electronics Engineer", biography: "Sam was responsible for the electronics system in the Flavor Fusion project, focusing on distributing power, enabling actuation, sensing, data storage, and user interaction through a display. His work involved managing approximately 30 active components, including sensors, motors, and processors, and he selected all parts from inventory rather than fabricating any due to the precision needed. Sam approached the project iteratively, beginning by testing each component individually before moving on to subsystem and integrated testing. He spent significant time configuring complex parts, such as the LCD, stepper motors, and Bluetooth communication, as these required detailed tuning and debugging. Throughout the project, Sam encountered various challenges with hardware, software, and integration, which he addressed by isolating issues, using tools like multimeters. His approach allowed him to troubleshoot effectively and, if necessary, simplify the design to achieve reliable functionality.", imageName: "sam"),
        TeamMember(name: "Alexandra Figueroa", position: "CAD Queen", biography: "Alexandra led the 3D Printing and Integration development, overseeing all aspects of the device to ensure seamless integration across subsystems. She managed key components, including the housing, carriage, dispensing zone, and motor mounts, which were essential in combining the purchased and fabricated parts into the final system. Due to the large size of the device, 3D printing required long lead times, so Alexandra focused on refining designs in CAD to address spacing, fitment, spice dosing accuracy, and interaction with the app and dispenser before each print. Prototyping allowed the team to assemble the device and gain valuable insights into optimizing the design for smoother assembly and potential future production. To meet food safety goals, Alexandra planned to use food-safe PETG material for the final version, although initial prototypes were printed with PLA for efficiency. The device’s 14-inch diameter posed a challenge, as it exceeded the capacity of available 3D printers, requiring parts to be spliced and welded together. Alexandra addressed this by carefully designing the components to ensure structural stability and reliability in the final assembly.", imageName: "alex"),
        TeamMember(name: "Thomas Spurlock", position: "Engineer", biography: "Thomas led the design and development of the dispensing mechanism, focusing on key objectives to ensure it was food-safe, easy to clean, easy to load, and resistant to spice leeching. The dispenser consists of six main components: the housing, funnel, auger, drive shaft, bearing cage, and bearing. Most parts were custom-designed and 3D printed to meet specific requirements, except for the COTS bearing, which required high precision. The design process involved extensive prototyping to refine features like snap-fit assemblies and compliant mechanisms to simplify cleaning and maintenance. With ten dispensers in the system, printing all components took approximately 40 hours, followed by post-manufacturing steps to remove support material and ensure quality fitment. A critical aspect of Thomas’s design work involved selecting the optimal spice bottle size and configuring the drop zone’s height and location to limit space constraints. Additionally, Thomas prioritized design choices to prevent spice leeching, drawing from powder-handling machinery techniques to avoid cross-contamination and protect against premature component wear. The design path also considered dishwasher compatibility, an essential factor for ease of use, as smaller parts like the auger required careful attention to avoid loss during cleaning.", imageName: "thomas"),
        TeamMember(name: "Ethan Butterfield", position: "Engineer", biography: "Ethan led the housing subsystem, focusing on ensuring the device met design objectives for size and safety. His primary goals were to create a device compact enough to fit in a cabinet or cupboard and free of sharp edges, achieved by applying a 2mm fillet or chamfer to all edges. Using SolidWorks, he designed nine major housing components, including parts like the carriage, motor mounts, housing shell, and LCD cover, with only the Lazy Susan being purchased. Due to the carriage’s dependence on the dispenser’s dimensions, it required a longer design and print time.", imageName: "ethan")
    ]
    
    @State private var selectedMember: TeamMember? = nil

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            
            VStack(spacing: 20) {
                // Iterating through rows
                ForEach(0..<3) { row in
                    HStack(spacing: 20) {
                        // Iterating through columns
                        ForEach(0..<2) { column in
                            if let index = self.indexFor(row: row, column: column) {
                                // Displaying team member view
                                TeamMemberView(member: self.teamMembers[index], showImage: !isLandscape)
                                    .onTapGesture {
                                        self.selectedMember = self.teamMembers[index]
                                    }
                            } else {
                                Spacer()
                            }
                        }
                    }
                }
            }
            .padding()
            .sheet(item: $selectedMember) { member in
                BiographyView(member: member)
            }
        }
    }

    /// Calculates the index for the team members array based on the row and column.
    ///
    /// - Parameters:
    ///   - row: The row index.
    ///   - column: The column index.
    /// - Returns: The index for the team members array or nil if out of bounds.
    func indexFor(row: Int, column: Int) -> Int? {
        let index = row * 2 + column
        return index < teamMembers.count ? index : nil
    }
}

// Preview Provider for the TeamView
#Preview {
    TeamView()
}
