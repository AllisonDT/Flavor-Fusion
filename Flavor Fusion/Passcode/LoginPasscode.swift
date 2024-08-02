//
//  LoginPasscode.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 3/25/24.
//

import SwiftUI
import CryptoKit

/// A view for logging in using a passcode.
///
/// The `LoginPasscode` view allows users to input a passcode to log in.
/// It provides a secure text field for entering the passcode and a grid of
/// buttons for passcode input. It also includes validation and error handling
/// for incorrect passcodes.
struct LoginPasscode: View {
    // State variables to manage passcode input and login status
    @State private var passcode: String = ""
    @State private var isLoginSuccessful: Bool = false
    @State private var showIncorrectPasscodeMessage: Bool = false
    @State private var isPasscodeVisible: Bool = false

    // Layout for the passcode buttons
    let gridLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                // Title
                Text("Enter Passcode")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 50)
                
                Spacer()
                
                // Passcode input field
                if isPasscodeVisible {
                    TextField("Passcode", text: $passcode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 10)
                } else {
                    SecureField("Passcode", text: $passcode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 10)
                }
                
                // Show Passcode Toggle
                Toggle("Show Passcode", isOn: $isPasscodeVisible)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                
                // Grid of passcode buttons
                LazyVGrid(columns: gridLayout, spacing: 20) {
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
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Login button
                Button(action: login) {
                    Text("Login")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 40)
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .alert(isPresented: $showIncorrectPasscodeMessage) {
                Alert(title: Text("Incorrect Passcode"), message: Text("Please try again."), dismissButton: .default(Text("OK")))
            }
            .navigationDestination(isPresented: $isLoginSuccessful) {
                ListTabView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    /// Adds a digit to the passcode.
    ///
    /// - Parameter number: The digit to be added.
    func addToPasscode(number: String) {
        passcode += number
    }
    
    /// Deletes the last digit from the passcode.
    func deleteLast() {
        if !passcode.isEmpty {
            passcode.removeLast()
        }
    }
    
    /// Handles the login attempt.
    ///
    /// Retrieves the stored passcode and compares it with the entered passcode.
    /// If the passcode is correct, sets the login success flag to true.
    /// If the passcode is incorrect, shows an error message.
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
