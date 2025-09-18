//
//  LoginScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/30/25.
//

import SwiftUI

struct LoginScreen: View {
    
    @State private var email: String = "tester@test.com"
    @State private var password: String = "12345678"
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    @State var selectedTag: String?
    
    @Environment(\.authenticationController) private var authenticationController
    
    private var isFormValid: Bool {
        !email.isEmptyOrWhitespace && !password.isEmptyOrWhitespace
    }
    
    private func login() async {
        do {
            isAuthenticated = try await authenticationController.login(email: email, password: password)
            print(isAuthenticated)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Welcome Back")
                    .font(.title).foregroundColor(.blue)) {
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .foregroundColor(.primary)
                    
                    SecureField("Password", text: $password)
                        .textInputAutocapitalization(.never)
                        .foregroundColor(.primary)
                }
                .padding(.top)
                
                Section {
                    HStack {
                        Button(action: {
                            Task {await login () }
                        }) {
                            Text("Login")
                        }
                        .disabled(!isFormValid)
                        .buttonStyle(OlivePrimaryButtonStyle())
                        .listRowBackground(Color.clear)
                        .frame(width:120, height: 40, alignment: .leading)
                        
                        Button(action: {
                        }, label: {
                            Text("Forgot Password?")
                        })
                        .background(
                            NavigationLink ( destination: ForgotPasswordScreen() ) {
                                EmptyView()
                            }
                        )
                        .listRowBackground(Color.clear)
                        .frame(width:200, height: 40, alignment: .trailing)
                    }
                    //.listRowBackground(Color.clear)
                }
                
                
                Button(action: {
                }, label: {
                    Text("Register Instead")
                })
                .background(
                    NavigationLink ( destination: RegistrationScreen() ) {
                        EmptyView()
                           
                    }
                    )
                .frame(width:300, height: 40, alignment: .center)
                .buttonStyle(OliveSecondaryButtonStyle())
                .listRowBackground(Color.clear)
                
            }
        }
    }
}

#Preview {
    LoginScreen()
}
