//
//  RegistrationScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/30/25.
//

import SwiftUI

struct RegistrationScreen: View {
    
    @Environment(\.authenticationController) var authenticationController
    
    @State private var registrationForm = RegistrationForm()
    @State private var messageText: String?
    @State private var errors: [String] = []
    
    private func register() async {
        do {
            let response = try await authenticationController.register(name: registrationForm.name, email: registrationForm.email, password: registrationForm.password)
            messageText = "✅ Registration successful! Welcome, \(response.name)!"
        }
        catch {
            messageText = "❌ Registration failed: \(error.localizedDescription)"
        }
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $registrationForm.name)
            TextField("Email", text: $registrationForm.email)
            SecureField("Password", text: $registrationForm.password)
            SecureField("Confirm Password", text: $registrationForm.confirm)
            Button("Register") {
                errors = registrationForm.validate()

                if errors.isEmpty {
                  Task { await register()}
                }
              
            } //.disabled(!registrationForm.isValid)
            
            if let messageText {
                Text(messageText)
                    .foregroundColor(messageText.contains("failed") ? .red : .green)
                    .multilineTextAlignment(.center)
            }
            
            if !errors.isEmpty {
                ValidationSummaryView(errors: errors)
            }
        }
    }
}

extension RegistrationScreen {
    
    private struct RegistrationForm {
        var name: String = "John Doe"
        var email: String = "johndoe@gmail.com"
        var password: String = "password1234"
        var confirm: String = ""
        
        var isValid: Bool {
            validate().isEmpty
        }
        
        func validate() -> [String] {
            var errors: [String] = []
            if name.isEmptyOrWhitespace {
                errors.append("Name cannot be empty")
            }
            
            if email.isEmptyOrWhitespace {
                errors.append("Email cannot be empty")
            }
            if password.isEmptyOrWhitespace {
                errors.append( "Password cannot be empty")
            }
            if !password.isValidPassword {
                errors.append("Password must be at least 8 characters long")
            }
            if password != confirm {
                errors.append("Password and confirmation password must match")
            }
            if !email.isEmail {
                errors.append("Email must be in correct format")
            }
            
            return errors
            
        }
    }
}

#Preview {
    RegistrationScreen()
}
