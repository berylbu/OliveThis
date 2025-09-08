//
//  RegistrationDTO.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/30/25.
//

import Foundation

struct RegistrationResponse: Codable {
    var data: Registration? = nil
    var error: APIError? = nil
}

struct Registration: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let id: Int
}

struct RegistrationRequest: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
