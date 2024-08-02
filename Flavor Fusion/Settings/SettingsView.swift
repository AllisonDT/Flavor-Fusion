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
/// as well as an input field for changing the display name.
struct SettingsView: View {
    @State private var currentPasscode: String = ""
    @State private var newPasscode: String = ""
    @State private var confirmPasscode: String = ""
    @State private var isPasscodeChangeSuccessful: Bool = false
    @State private var showIncorrectPasscodeMessage: Bool = false
    
    @State private var displayName: String = UserDefaults.standard.string(forKey: "displayName") ?? ""
    @State private var isDisplayNameChangeSuccessful: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
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
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("Settings", displayMode: .inline)
            .alert(isPresented: $showIncorrectPasscodeMessage) {
                Alert(title: Text("Incorrect Passcode"), message: Text("Please enter the correct current passcode."), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $isPasscodeChangeSuccessful) {
                Alert(title: Text("Passcode Changed"), message: Text("Your passcode has been successfully changed."), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $isDisplayNameChangeSuccessful) {
                Alert(title: Text("Display Name Changed"), message: Text("Your display name has been successfully changed."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    /// Changes the passcode after validating the current passcode and confirming the new passcode.
    func changePasscode() {
        guard let storedPasscode = UserDefaults.standard.string(forKey: "passcode") else {
            print("No passcode saved.")
            return
        }

        if currentPasscode == storedPasscode {
            if newPasscode == confirmPasscode {
                UserDefaults.standard.set(newPasscode, forKey: "passcode")
                print("Passcode changed successfully!")
                isPasscodeChangeSuccessful = true
            } else {
                print("New passcode and confirm passcode do not match.")
                showIncorrectPasscodeMessage = true
            }
        } else {
            print("Incorrect current passcode. Please try again.")
            showIncorrectPasscodeMessage = true
        }
    }
    
    /// Changes the display name and saves it to UserDefaults.
    func changeDisplayName() {
        UserDefaults.standard.set(displayName, forKey: "displayName")
        isDisplayNameChangeSuccessful = true
    }
}

// Preview Provider for the SettingsView
#Preview {
    SettingsView()
}
