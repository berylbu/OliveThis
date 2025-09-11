//
//  RegistrationScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/30/25.
//

enum RegistrationStatus: Int {
    case pending
    case success
    case failed
}

import SwiftUI

struct RegistrationScreen: View {
    
    @Environment(\.authenticationController) private var authenticationController
    
    @State private var registrationForm = RegistrationForm()
    @State private var messageText: String = ""
    @State private var regStatus = RegistrationStatus.pending
    @State var isSecure: Bool = true
    @State private var registrationSuccess: Bool = false

    @State private var errors: [String] = []

    private func register() async {
        if registrationForm.isValid {
            do {
                let response = try await authenticationController.register(
                    firstName: registrationForm.firstName,
                    lastName: registrationForm.lastName,
                    email: registrationForm.email,
                    password: registrationForm.password
                )
                
                if (response.error != nil) {
                    regStatus = .failed
                    if response.error?.errorCode == 409 {
                        messageText = "❌ This email address is already registered."
                    }
                    else {
                        messageText = "❌ \(response.error?.userMsg ?? "Unknown failure")"
                    }
                }
                else {
                    regStatus = .success
                    registrationSuccess = true
                }
                
            } catch {
                regStatus = .failed
                messageText = "❌ \(error.localizedDescription)"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Create Account")) {
                    TextField("First Name", text: $registrationForm.firstName)
                        .textContentType(.name)
                        .autocapitalization(.words)
                    
                    TextField("Last Name", text: $registrationForm.lastName)
                        .textContentType(.name)
                        .autocapitalization(.words)

                    TextField("Email", text: $registrationForm.email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                    
                    PasswordTextView(text: $registrationForm.password, titleKey: "Password")
                    
                    PasswordTextView(text: $registrationForm.confirmPassword, titleKey: "Confirm Password")

                }
                
                Button(action: {
                    errors = registrationForm.validate()
                    if errors.isEmpty {
                        Task { await register() }
                    }
                }) {
                    Text("Register")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .buttonStyle(OlivePrimaryButtonStyle())
                .listRowBackground(Color.clear)
                
                Section {
                    if !messageText.isEmpty {
                        RegistrationFailView(messageText: messageText)
                    }
                }
                
                Section {
                    if !errors.isEmpty {
                        ValidationSummaryView(errors: errors)
                    }
                }
               

            }
            .sheet(isPresented: $registrationSuccess, content: {
                NavigationStack {
                    RegistrationSuccessScreen(emailAddress: $registrationForm.email.wrappedValue, isVerified: false)
                }
            })
            .navigationTitle("Register")
        }
    }
}


extension RegistrationScreen {
    
    private struct RegistrationForm {
        var firstName: String = "test"
        var lastName: String = "test"
        var email: String = "test@test.com"
        var password: String = "12345678"
        var confirmPassword: String = "12345678"
        var isTermsAccepted: Bool = false
        
        var isValid: Bool {
            validate().isEmpty
        }
        
        func validate() -> [String] {
            
            var errors: [String] = []
            
            if firstName.isEmptyOrWhitespace {
                errors.append("First name cannot be empty.")
            }
            
            if lastName.isEmptyOrWhitespace {
                errors.append("Last name cannot be empty.")
            }
            
            if email.isEmptyOrWhitespace {
                errors.append("Email cannot be empty.")
            }
            
            if password.isEmptyOrWhitespace {
                errors.append("Password cannot be empty.")
            }
            
            if !password.isValidPassword {
                errors.append("Password must be at least 8 characters long.")
            }
            
            if password != confirmPassword {
                errors.append("Password and confirm password do not match.")
            }
            
            if !email.isEmail {
                errors.append("Email must be in correct format.")
            }
            
            return errors
        }
        
    }
    
}

#Preview {
    RegistrationScreen()
}
