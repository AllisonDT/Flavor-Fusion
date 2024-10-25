//
//  List.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 3/24/24.
//

import SwiftUI
import UserNotifications

/// A view that displays a list of spices, allows blending, and monitors spice levels.
///
/// `List` presents a view where users can view, select, and blend spices. It also tracks when spices are running low
/// and triggers a notification. Users can refresh the list, check the last update time, and interact with the spices via popups.
///
/// - Parameters:
///   - isSelecting: A boolean state that determines if the user is in spice selection mode.
///   - isBlendPopupVisible: A boolean state controlling the visibility of the blend popup view.
///   - isSpicePopupVisible: A boolean state controlling the visibility of the spice popup view for the selected spice.
///   - selectedSpice: An optional `Spice` object representing the currently selected spice for detailed view.
///   - recipeStore: An `ObservedObject` for managing the list of recipes.
///   - displayName: A string representing the display name of the user, fetched from `UserDefaults`.
///   - isLoading: A boolean state that shows if the spices are being refreshed.
///   - lastUpdated: An optional `Date` representing the last time the spice list was updated.
///   - spiceDataViewModel: An `ObservedObject` for managing the spice data.
struct List: View {
    @State private var isSelecting: Bool = false
    @State private var isBlendPopupVisible: Bool = false
    @State private var isSpicePopupVisible: Bool = false
    @State private var selectedSpice: Spice?
    @ObservedObject var recipeStore = RecipeStore()
    @State private var displayName: String = UserDefaults.standard.string(forKey: "displayName") ?? "Flavor Fusion"
    @State private var isLoading: Bool = false
    @State private var lastUpdated: Date?
    @ObservedObject var spiceDataViewModel = SpiceDataViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Always show the last updated date
                    Text("Last updated: \(formattedDate(lastUpdated ?? Date()))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)

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
                            ForEach(spiceDataViewModel.spices.filter { $0.containerNumber % 2 != 0 }) { spice in
                                SpiceRow(spiceDataViewModel: spiceDataViewModel, spice: spice, isSelecting: isSelecting, recipes: recipeStore.recipes) { selected in
                                    if let index = spiceDataViewModel.spices.firstIndex(where: { $0.id == spice.id }) {
                                        spiceDataViewModel.spices[index].isSelected = selected
                                    }
                                }
                                .onTapGesture {
                                    selectedSpice = spice
                                    isSpicePopupVisible = true
                                }
                            }
                        }
                        
                        VStack {
                            ForEach(spiceDataViewModel.spices.filter { $0.containerNumber % 2 == 0 }) { spice in
                                SpiceRow(spiceDataViewModel: spiceDataViewModel, spice: spice, isSelecting: isSelecting, recipes: recipeStore.recipes) { selected in
                                    if let index = spiceDataViewModel.spices.firstIndex(where: { $0.id == spice.id }) {
                                        spiceDataViewModel.spices[index].isSelected = selected
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
            }
            .refreshable {
                refreshSpices()
            }
            .sheet(isPresented: $isBlendPopupVisible) {
                BlendingNewExistingView(isPresented: $isBlendPopupVisible, spiceDataViewModel: spiceDataViewModel)
            }
            .sheet(isPresented: $isSpicePopupVisible) {
                if let selectedSpice = selectedSpice {
                    SpicePopupView(spice: selectedSpice, recipes: recipeStore.recipes, isPresented: $isSpicePopupVisible, spiceDataViewModel: spiceDataViewModel)
                }
            }
            .navigationBarTitle("\(displayName)'s Cabinet", displayMode: .inline)
            .onAppear {
                requestNotificationPermission()
                checkSpiceLevels()
                if lastUpdated == nil {
                    lastUpdated = Date()
                }
            }
        }
    }

    private func refreshSpices() {
        isLoading = true
        
        // Simulate a network or data fetch
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            spiceDataViewModel.loadSpices() // Reload spices from UserDefaults or other source
            lastUpdated = Date()
            isLoading = false
        }
    }

    private func checkSpiceLevels() {
        var lowSpices: [Spice] = []
        
        for spice in spiceDataViewModel.spices {
            if spice.spiceAmount < 4.0 {
                lowSpices.append(spice)
            }
        }
        
        if !lowSpices.isEmpty {
            triggerLowSpiceNotification(for: lowSpices)
        }
    }

    private func triggerLowSpiceNotification(for lowSpices: [Spice]) {
        let spiceNames = lowSpices.map { $0.name }.joined(separator: ", ")
        let content = UNMutableNotificationContent()
        content.title = "Spices Running Low"
        content.body = spiceNames
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error triggering notification: \(error.localizedDescription)")
            } else {
                print("Low spice notification triggered for: \(spiceNames).")
            }
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            } else if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct List_Previews: PreviewProvider {
    static var previews: some View {
        List()
    }
}
