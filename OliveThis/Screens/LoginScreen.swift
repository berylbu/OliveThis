//
//  LoginScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/30/25.
//

import SwiftUI

struct LoginScreen: View {
    
    @State private var email: String = "test@test.com"
    @State private var password: String = "password"
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
                Section(header: Text("Welcome Back").font(.headline).foregroundColor(.blue)) {
                    
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
                    Button(action: {
                        Task {await login () }
                    }) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.headline)
                            .background(isFormValid ? Color.blue : Color.gray.opacity(0.5))
                            .cornerRadius(8)
                    }
                    .disabled(!isFormValid)
                    .listRowBackground(Color.clear)
                }
                
                Button(action: {
                }, label: {
                    Text("forgot password?")
                })
                .background(
                    NavigationLink ( destination: ForgotPasswordScreen() ) {
                        EmptyView()
                    }
                    )
                
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
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                       
                
            }
        }
    }
}

#Preview {
    LoginScreen()
}
