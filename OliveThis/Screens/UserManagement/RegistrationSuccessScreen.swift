//
//  RegistrationSuccess.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/8/25.
//

import SwiftUI

public struct RegistrationSuccessScreen: View {
    
    let emailAddress: String
    @State public var isVerified = false
    
    public var body: some View {
        Form {
            if !isVerified {
                Text("✅ Registration is complete.  Please validate your email and then return to the login screen to log in.")
                    .font(.headline)
                    .padding()
                Text("Enter the code we emailed to \(emailAddress) below:")
                    .font(.subheadline)
                    .padding()
                TextField("Verification Code", text: .constant(""))
                    .padding()
                Button("Verify") {
                    isVerified = true
                }
            }
            else {
                Text("✅ Verification was successful.  Please log in.")
                    .font(.headline)
                    .padding()
                LoginScreen()
            }
        }
    }
}

#Preview {
    RegistrationSuccessScreen(emailAddress: "test@test.com", isVerified: false)
}
