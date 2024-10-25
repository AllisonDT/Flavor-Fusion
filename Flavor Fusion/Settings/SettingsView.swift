//
//  SettingsView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 3/24/24.
//

import SwiftUI

/// A view that provides settings options for the Flavor Fusion app.
///
/// `SettingsView` allows users to change their passcode and display name. It provides
/// input fields for the current passcode, new passcode, and confirmation of the new passcode,
/// as well as an input field for changing the display name. It also includes an option to toggle
/// whether the passcode screen is required when the app opens.
struct SettingsView: View {
    @State private var currentPasscode: String = ""
    @State private var newPasscode: String = ""
    @State private var confirmPasscode: String = ""
    
    @State private var displayName: String = UserDefaults.standard.string(forKey: "displayName") ?? ""
    @State private var requiresPasscode: Bool = UserDefaults.standard.object(forKey: "requiresPasscode") as? Bool ?? false
    
    @State private var alertType: AlertType? = nil
    
    // Use BLEManager from the environment
    @EnvironmentObject var bleManager: BLEManager

    enum AlertType: Identifiable {
        case incorrectPasscode
        case passcodeChanged
        case displayNameChanged
        
        var id: String {
            switch self {
            case .incorrectPasscode: return "incorrectPasscode"
            case .passcodeChanged: return "passcodeChanged"
            case .displayNameChanged: return "displayNameChanged"
            }
        }
        
        var title: String {
            switch self {
            case .incorrectPasscode: return "Incorrect Passcode"
            case .passcodeChanged: return "Passcode Changed"
            case .displayNameChanged: return "Display Name Changed"
            }
        }
        
        var message: String {
            switch self {
            case .incorrectPasscode: return "Please enter the correct current passcode."
            case .passcodeChanged: return "Your passcode has been successfully changed."
            case .displayNameChanged: return "Your display name has been successfully changed."
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Bluetooth connection status
                    HStack {
                        Text("Bluetooth Status:")
                            .font(.headline)
                        Spacer()
                        if bleManager.isBluetoothConnected {
                            Text("Connected")
                                .foregroundColor(.green)
                        } else {
                            Text("Not Connected")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    Group {
                        Text("Change Passcode")
                            .font(.headline)
                            .bold()
                            .padding(.bottom, 5)
                        
                        SecureField("Current Passcode", text: $currentPasscode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        SecureField("New Passcode", text: $newPasscode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        SecureField("Confirm Passcode", text: $confirmPasscode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: changePasscode) {
                            Text("Change Passcode")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    Group {
                        Text("Change Display Name")
                            .font(.headline)
                            .bold()
                            .padding(.bottom, 5)
                        
                        TextField("Display Name", text: $displayName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: changeDisplayName) {
                            Text("Change Display Name")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    Group {
                        Text("Require Passcode at Startup")
                            .font(.headline)
                            .bold()
                            .padding(.bottom, 5)
                        
                        Toggle(isOn: $requiresPasscode) {
                            Text("Require Passcode")
                        }
                        .padding(.horizontal)
                        .onChange(of: requiresPasscode) {
                            UserDefaults.standard.set(requiresPasscode, forKey: "requiresPasscode")
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("Settings", displayMode: .inline)
            .alert(item: $alertType) { alertType in
                Alert(title: Text(alertType.title), message: Text(alertType.message), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func changePasscode() {
        guard let storedPasscode = UserDefaults.standard.string(forKey: "passcode") else {
            print("No passcode saved.")
            return
        }

        if currentPasscode == storedPasscode {
            if newPasscode == confirmPasscode {
                UserDefaults.standard.set(newPasscode, forKey: "passcode")
                print("Passcode changed successfully!")
                alertType = .passcodeChanged
                clearPasscodeFields() // Clear the fields after a successful change
            } else {
                print("New passcode and confirm passcode do not match.")
                alertType = .incorrectPasscode
            }
        } else {
            print("Incorrect current passcode. Please try again.")
            alertType = .incorrectPasscode
        }
    }
    
    func clearPasscodeFields() {
        currentPasscode = ""
        newPasscode = ""
        confirmPasscode = ""
    }
    
    func changeDisplayName() {
        UserDefaults.standard.set(displayName, forKey: "displayName")
        alertType = .displayNameChanged
    }
}


#Preview {
    SettingsView()
}

