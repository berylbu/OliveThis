//
//  RegistrationResultView.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/7/25.
//

import SwiftUI

struct RegistrationResultView: View {
    let regStatus: RegistrationStatus
    let messageText: String
    let verifyCode: Int?
    
    var body: some View {
        
        NavigationStack {
            if regStatus == RegistrationStatus.success {
                RegistrationSuccess()
            }
            else {
                Text("Registration Result")
                    .font(.headline)
            }
            Text(messageText)
            
        }
    }
}

#Preview {
    RegistrationResultView(regStatus: .failed, messageText: "Already exists", verifyCode: 1234)
}
