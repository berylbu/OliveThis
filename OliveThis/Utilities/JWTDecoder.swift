//
//  JWTDecoder.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/30/25.
//

import Foundation

struct JWTDecoder {
    static func isExpired(token: String) -> Bool {
        guard let payload = try? decodePayload(token),
              let expiryDate = payload["exp"] as? TimeInterval else {
            return true 
        }
        
        print(payload)
        print(expiryDate)
        return Date().timeIntervalSince1970 > expiryDate
    }
    
    static func decodePayload(_ token: String) throws -> [String: Any] {
        
        let segments = token.split(separator: ".")
        guard segments.count >= 2 else {
            throw JWTError.invalidFormat
        }
        
        let payloadSegment = segments[1]
        
        //convert from base64url to base64
        var base64 = payloadSegment
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        //add padding if needed
        let paddingLength = 4 - (base64.count % 4)
        if paddingLength < 4 {
            base64 += String(repeating: "=", count: paddingLength)
        }
        
        guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else {
            throw JWTError.invalidBase64
        }
        
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard let payload = json as? [String: Any] else {
            throw JWTError.invalidJSON
        }
        
        return payload
    }
    
    
    enum JWTError: Error {
        case invalidFormat
        case invalidBase64
        case invalidJSON
    }
}
