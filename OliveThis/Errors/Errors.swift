//
//  Errors.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/30/25.
//
import Foundation

enum NetworkError: Error {
    case badRequest
    case decodingError(Error)
    case internalServerError
    case invalidRequest
    case invalidResponse
    case invalidURL
    case notFound
    case urlSessionFailed
    case unauthorized
    case undefined(Data, HTTPURLResponse)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badRequest:
            return NSLocalizedString("Bad Request (400): Unable to perform the request.", comment: "Bad Request")
        case .decodingError:
            // ERROR IN ASAM CODE return NSLocalizedString("Unable to decode successfully. \(error)", comment: "Decoding Error")
            return NSLocalizedString("Unable to decode successfully.", comment: "Decoding Error")
        case .internalServerError:
            return NSLocalizedString("Invalid response.", comment: "Invalid response")
        case .invalidRequest:
            return NSLocalizedString("Invalid request.", comment: "Invalid request")
        case .invalidResponse:
            return NSLocalizedString("Invalid response.", comment: "Invalid response")
        case .invalidURL:
            return NSLocalizedString("Invalid URL.", comment: "Invalid URL")
        case .notFound:
            return NSLocalizedString("Not Found (404).", comment: "Not Found")
        case .urlSessionFailed:
            return NSLocalizedString("URL Session Failed.", comment: "URL Session Failed")
        case .unauthorized:
            return NSLocalizedString("Unauthorized", comment: "Unauthorized")
        case .undefined(let data, let response):
            if let decoded = try? JSONDecoder().decode(ErrorResponse.self, from: data),
               let message = decoded.message {
                return message
            } else {
                return "Unknown Error: \(response.statusCode)"
            }
        }
    }
    
}
