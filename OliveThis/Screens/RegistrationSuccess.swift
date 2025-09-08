//
//  RegistrationSuccess.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/8/25.
//

import SwiftUI

struct RegistrationSuccess: View {
    
    private var isVerified = false
    
    var body: some View {
        VStack {
            if !isVerified {
                Text("✅ Registration is complete.  Please validate your email and then return to the login screen to log in.")
                    .font(.headline)
                    .padding()
                Text("Please verify your login code below:")
                    .font(.caption)
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
    RegistrationSuccess()
}
