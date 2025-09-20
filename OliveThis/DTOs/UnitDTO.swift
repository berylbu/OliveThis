//
//  UnitDTO.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/19/25.
//

import Foundation

struct UnitsResponse: Codable {
    var data: [Unit]? = nil
    var error: APIError? = nil
}

struct UnitResponse: Codable {
    var data: Unit? = nil
    var error: APIError? = nil
}

struct Unit: Codable, Identifiable, Hashable  {
    
    let unitID: Int64 
    let categoryID:  Int
    var subcategoryID: Int
    var appUserID: String
    
    var createdDate: String
    var lastEditedDate: String
    
    var userTried: Bool
    var rating: Int
    
    var name: String
    var notes: String?
    
    var personFirstName: String?
    var personLastName: String?
    var secondPersonFirstName: String?
    var secondPersonLastName: String?
    
    var address1: String?
    var address2: String?
    var city: String?
    var region: String?
    var postalCode: String?
    
    var telephoneNumber: String?
    var telephoneNumber2: String?
    var webLink: String?
    var imageLink: String?
    
    var recByFirstName: String?
    var recByLastName: String?
    var recByAppUserID: String?
    
    var id: Int64 {
        unitID
    }
}




