//
//  Constants.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/30/25.
//

import Foundation

struct Constants {
    
    struct Urls {
        
        static let login = URL(string: "https://oliveit-bsavb4aybuacaqb2.centralus-01.azurewebsites.net/api/auth/login")!
        static let refreshToken = URL(string: "https://oliveit-bsavb4aybuacaqb2.centralus-01.azurewebsites.net/api/auth/login")!
        
        static let register = URL(string: "https://oliveit-bsavb4aybuacaqb2.centralus-01.azurewebsites.net/user/register")!
        
        static let createCategory = URL(string: "https://api.escuelajs.co/api/v1/categories/")!
        static let createProduct = URL(string: "https://api.escuelajs.co/api/v1/products/")!
        static let locations = URL(string: "https://api.escuelajs.co/api/v1/locations")!
        
        static func deleteProduct(_ productId: Int) -> URL {
            URL(string: "https://api.escuelajs.co/api/v1/products/\(productId)")!
        }
        
        static func getProductsByCategory(_ categoryId: Int) -> URL {
            URL(string: "https://api.escuelajs.co/api/v1/categories/\(categoryId)/products")!
        }
        
        //META DATA
        static let categories = URL(string: "https://oliveit-bsavb4aybuacaqb2.centralus-01.azurewebsites.net/categorysub/getdefaultcategories")!
        
        static func getSubcategoriesByCategory(_ categoryId: Int) -> URL {
            URL(string: "https://oliveit-bsavb4aybuacaqb2.centralus-01.azurewebsites.net/categorysub/getsubcategoriesbycat")!
        }
        
        //USER DATA
        static let userCategories = URL(string: "https://oliveit-bsavb4aybuacaqb2.centralus-01.azurewebsites.net/categorysub/getdefaultcategories")!
        
        static func getUserSubcategoriesByCategory(_ categoryId: Int) -> URL {
            URL(string: "https://oliveit-bsavb4aybuacaqb2.centralus-01.azurewebsites.net/categorysub/getsubcategoriesbycat")!
        }
 
    }
    
}
