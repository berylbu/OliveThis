//
//  AuthenticationController.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/30/25.
//

import Foundation

struct AuthenticationController {
    
    // If mocking then use HTTPClientProtocol
    let httpClient: HTTPClient
    
    func checkAuthentication() async -> Bool {
        
        guard let accessToken: String = Keychain.get("accessToken") else {
            return false
        }
        
        // check if access token is expired
        if JWTDecoder.isExpired(token: accessToken) {
            do {
                try await httpClient.refreshToken() //needs work - did this call work?
                return true
            } catch {
                return false
            }
        }
        
        return true
    }
    
    func signOut() {
        UserDefaults.standard.removeObject(forKey: "isAuthenticated")
        let _ = Keychain<String>.delete("accessToken")
        let _ = Keychain<String>.delete("refreshToken")
        let _ = Keychain<String>.delete("userToken")
    }
    
    func register(firstName: String, lastName: String, email: String, password: String) async throws -> RegistrationResponse {
        
        let request = RegistrationRequest(firstName: firstName, lastName: lastName, email: email, password: password)
        let resource = Resource(url: Constants.Urls.register, method: .post(try request.encode()), modelType: RegistrationResponse.self)
        let response = try await httpClient.load(resource)
        return response
    }
    
    func login(email: String, password: String) async throws -> Bool {
        
        let request = LoginRequest(email: email, password: password)
        let resource = Resource(url: Constants.Urls.login, method: .post(try request.encode()), modelType: LoginResponse.self)
        let response = try await httpClient.load(resource)
        
        print(response.accessToken)
        print(response.refreshToken)
        
        // save the access and refresh token in Keychain
        Keychain.set(response.accessToken, forKey: "accessToken")
        Keychain.set(response.refreshToken, forKey: "refreshToken")
        Keychain.set(response.userToken, forKey: "userToken")

        return true
    }
    
}
