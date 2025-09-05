//
//  APIDTO.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/30/25.
//

import Foundation
import MapKit

struct RefreshTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

struct RegistrationResponse: Codable {
    let email: String
    let password: String
    let name: String
    let avatar: URL
    let role: String
    let id: Int
}

struct RegistrationRequest: Codable {
    let name: String
    let email: String
    let password: String
    let avatar: URL
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

struct ErrorResponse: Codable {
    let message: String?
}



struct CreateCategoryRequest: Codable {
    let name: String
    let image: URL
}

struct Product: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let images: [URL]
}

extension Product {
    static var preview: Product {
        Product(
            id: 1,
            title: "Handmade Fresh Table",
            price: 687.0,
            description: "Andy shoes are designed to keep in comfort and style. Perfect for your next dinner party or client meeting.",
            images: [
                URL(string: "https://i.imgur.com/qNOjJje.jpeg")!,
                URL(string: "https://i.imgur.com/qNOjJje.jpeg")!,
                URL(string: "https://i.imgur.com/qNOjJje.jpeg")!
            ]
        )
    }
}

struct CreateProductRequest: Codable {
    let title: String
    let price: Double
    let description: String
    let categoryId: Int
    let images: [URL]
}

struct Location: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

