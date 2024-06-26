//
//  LoginPasscode.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 3/25/24.
//

import SwiftUI
import CryptoKit

struct LoginPasscode: View {
    // State variables to manage passcode input and login status
    @State private var passcode: String = ""
    @State private var isLoginSuccessful: Bool = false
    @State private var showIncorrectPasscodeMessage: Bool = false

    // Layout for the passcode buttons
    let gridLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Title
                Text("Enter Passcode")
                    .font(.title)
                    .padding()
                
                // Grid of passcode buttons
                LazyVGrid(columns: gridLayout, spacing: 10) {
                    ForEach(1...9, id: \.self) { number in
                        PasscodeButton(number: "\(number)") {
                            addToPasscode(number: "\(number)")
                        }
                    }
                    Spacer()
                    PasscodeButton(number: "Del") {
                        deleteLast()
                    }
                }
                .padding(.horizontal)
                
                // Secure text field for passcode input
                SecureField("Passcode", text: $passcode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Login button
                Button(action: login) {
                    Text("Login")
                }
                .padding()
                
                // Navigation link to ListTabView upon successful login
                NavigationLink(destination: ListTabView().navigationBarBackButtonHidden(true), isActive: $isLoginSuccessful) {
                    EmptyView()
                }
            }
            .padding()
            // Alert to show incorrect passcode message
            .alert(isPresented: $showIncorrectPasscodeMessage) {
                Alert(title: Text("Incorrect Passcode"), message: Text("Please try again."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // Function to add a digit to the passcode
    func addToPasscode(number: String) {
        passcode += number
    }
    
    // Function to delete the last digit from the passcode
    func deleteLast() {
        if !passcode.isEmpty {
            passcode.removeLast()
        }
    }
    
    // Function to handle login attempt
    func login() {
        // Retrieve the stored passcode from UserDefaults
        guard let storedPasscode = UserDefaults.standard.string(forKey: "passcode") else {
            print("No passcode saved.")
            // Handle the case where no passcode is saved (e.g., user hasn't set up passcode yet)
            return
        }

        // Compare the entered passcode with the stored passcode
        if passcode == storedPasscode {
            print("Login successful!")
            isLoginSuccessful = true // Navigate to ListTabView
        } else {
            print("Incorrect passcode. Please try again.")
            // Clear the passcode text field
            passcode = ""
            showIncorrectPasscodeMessage = true // Set flag to show the incorrect passcode message
        }
    }
}

struct LoginPasscode_Previews: PreviewProvider {
    static var previews: some View {
        LoginPasscode()
    }
}
