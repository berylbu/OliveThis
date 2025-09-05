//
//  CategoryDTO.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/31/25.
//

import Foundation

//struct Category: Identifiable, Codable {
//    let id: Int
//    let name: String
//    let image: URL
//}
//
//struct CreateCategoryRequest: Codable {
//    let name: String
//    let image: URL
//}

struct CatResponse: Codable {
    var data: [Category]? = nil
    var error: APIError? = nil
}

struct APIError: Codable {
    let developerMsg: String
    let userMsg: String
    let errorCode: Int
}

struct Category: Codable, Identifiable  {
    let categoryID: Int
    let categoryName: String
    let categoryDescription: String?
    let link: URL?
    let iconattribution: String?
    
    var id: Int {
        categoryID
    }
}
