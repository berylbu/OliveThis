//
//  HTTPClient.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/30/25.
//

import Foundation

enum HTTPMethod {
    case get([URLQueryItem])
    case post(Data?)
    case delete
    case put(Data?)
    
    var name: String {
        switch self {
        case .get:
                return "GET"
            case .post:
                return "POST"
            case .delete:
                return "DELETE"
            case .put:
                return "PUT"
        }
    }
}

struct Resource<T: Codable> {
    let url: URL
    var method: HTTPMethod = .get([])
    var headers: [String: String]? = nil
    var modelType: T.Type
}

struct HTTPClient {
    
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        self.session = URLSession(configuration: configuration)
    }
    
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
        do {
            return try await performRequest(resource)
        } catch NetworkError.unauthorized {
            //attempt to refreshs the token
            do {
                try await refreshToken()
                return try await performRequest(resource)
            }
            catch {
                throw NetworkError.unauthorized
            }
        } 
    }
    
    private func performRequest<T: Codable>(_ resource: Resource<T>) async throws -> T {
        var request = URLRequest(url: resource.url)
        
        switch resource.method {
        case .get(let queryItems):
            var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)!
            components.queryItems? = queryItems
            guard let url = components.url else {
                throw NetworkError.badRequest
            }
            request.url = url
        case .post(let data), .put(let data):
            request.httpMethod = resource.method.name
            request.httpBody = data
        case .delete:
            request.httpMethod = "DELETE"
        }
        
        //add authorization header // accesstoken
        if let token = Keychain<String>.get("accesstoken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let headers = resource.headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            break
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        default:
            throw NetworkError.undefined(data, httpResponse)
        }
        
        do {
            return try JSONDecoder().decode(resource.modelType, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
            
    }
    
    func refreshToken() async throws {
        
        guard let refreshToken = Keychain<String>.get("refreshtoken") else {
            throw NetworkError.unauthorized
        }
        
        let body = try JSONEncoder().encode(["refreshToken": refreshToken])
        let resource = Resource(url: Constants.Urls.refreshToken, method: .post(body), modelType: RefreshTokenResponse.self)
        let response = try await performRequest(resource)
        
        Keychain.set(response.accessToken, forKey: "accessToken")
        Keychain.set(response.refreshToken, forKey: "refreshToken")
    }
    
}
