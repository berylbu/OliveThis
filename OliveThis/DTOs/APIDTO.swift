//
//  APIDTO.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/30/25.
//

import Foundation


struct ErrorResponse: Codable {
    let message: String?
}

struct RefreshTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
