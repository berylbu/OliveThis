//
//  CategoryDTO.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/31/25.
//

import Foundation

struct Category: Codable, Identifiable, Hashable  {
    let categoryID: Int
    let categoryName: String
    let categoryDescription: String?
    let link: URL?
    let iconattribution: String?
    let sortID: Int
    
    var id: Int {
        categoryID
    }
}

struct CatResponse: Codable {
    var data: [Category]? = nil
    var error: APIError? = nil
}

struct Subcategory: Codable, Identifiable  {
    let subcategoryID: Int
    let categoryID: Int
    let subcategoryName: String
    let subcategoryDescription: String?
    let link: URL?
    let iconattribution: String?
    
    var id: Int {
        subcategoryID
    }
}

struct SubcatResponse: Codable {
    var data: [Subcategory]? = nil
    var error: APIError? = nil
}
