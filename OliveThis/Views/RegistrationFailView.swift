//
//  RegistrationResultView.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/7/25.
//

import SwiftUI

struct RegistrationFailView: View {

    let messageText: String
    
    var body: some View {
        
        NavigationStack {
                Text("Registration Result !!!")
                    .font(.headline)
                    .padding()
            Text(messageText)
                .foregroundColor(.red)
                .padding(.horizontal)
        }
    }
}

#Preview {
    RegistrationFailView(messageText: "Already exists")
}
