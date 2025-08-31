//
//  CategoryDTO.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/31/25.
//

import Foundation

struct Category: Identifiable, Codable {
    let id: Int
    let name: String
    let image: URL
}

struct CreateCategoryRequest: Codable {
    let name: String
    let image: URL
}
