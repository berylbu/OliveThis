//
//  UserDTO.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/8/25.
//

import Foundation

struct CatAllResponse: Codable {
    var data: [CategoriesAll]? = nil
    var error: APIError? = nil
}

struct CategoriesAll: Codable, Identifiable, Hashable  {
    let categoryID: Int
    var categoryName: String
    var isUsed: Bool
    var sortID: Int
    
    var id: Int {
        categoryID
    }
}

struct UserCatUpdateRequest: Codable {
    var categoryID: Int
    var sortID: Int
}

struct UserCatsUpdateRequest: Codable {
    var userCats : [UserCatUpdateRequest]
}

