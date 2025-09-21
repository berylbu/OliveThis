//
//  AccountScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/4/25.
//

import SwiftUI

struct AccountScreen: View {
    
    @Environment(\.authenticationController) private var authenticationController
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Section {
                    NavigationLink(destination: ManageCategoriesScreen())
                    {
                        Text("Manage Categories and Subcategories")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 40)
                    .navigationTitle("Account")
                }
                Section {
                    // Sign Out Button
                    Button(action: {
                        authenticationController.signOut()
                    }) {
                        Text("Sign Out")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                    .navigationTitle("AccountScreen")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AccountScreen()
    }
}
