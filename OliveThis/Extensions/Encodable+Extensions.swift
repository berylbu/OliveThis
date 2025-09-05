//
//  Encodable+Extensions.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/30/25.
//

import Foundation

extension Encodable {
    
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
    
}
