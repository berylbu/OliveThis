//
//  OliveThisApp.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/28/25.
//

import SwiftUI

@main
struct OliveThisApp: App {
    
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    @Environment(\.authenticationController) private var authenticationController
    @State private var isLoading: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoading {
                    ProgressView("Loading...")
                        .task {
                            isAuthenticated = await authenticationController.checkAuthentication()
                            isLoading = false
                        }
                } else if isAuthenticated {
                    HomeScreen()
                        .environment(OliveThisStore(httpClient: HTTPClient()))
                } else {
//                    VStack {
//                        RegistrationScreen()
//                        LoginScreen()
//                    }
                    LoginScreen()
                }
            }
        }
    }
}
