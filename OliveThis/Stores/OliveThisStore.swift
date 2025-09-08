//
//  OliveThisStore.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/31/25.
//

import Foundation
import Observation

@MainActor
@Observable
class OliveThisStore {
    
    let httpClient: HTTPClient
    var categories: [Category] = []
    var locations: [Location] = []
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    
    // META DATA
    func loadCategories() async throws {
        let resource = Resource(url: Constants.Urls.categories, modelType: CatResponse.self)
        let catResponse = try await httpClient.load(resource)
        categories = catResponse.data ?? []
    }
    
    func fetchSubcategoriesByCat(_ categoryId: Int) async throws -> [Subcategory] {
        let queryItems = [URLQueryItem(name: "categoryId", value: String(categoryId))]
        let resource = Resource(url: Constants.Urls.getSubcategoriesByCategory(categoryId), method: .get(queryItems), modelType: SubcatResponse.self)
        let subcatResponse = try await httpClient.load(resource)
        return subcatResponse.data ?? []
    }
    
    // USER SPECIFIC INFORMATION
    func loadUserCategories() async throws {
        let resource = Resource(url: Constants.Urls.userCategories, modelType: CatResponse.self)
        let catResponse = try await httpClient.load(resource)
        categories = catResponse.data ?? []
    }
    
    func fetchUserSubcategoriesByCat(_ categoryId: Int) async throws -> [Subcategory] {
        let queryItems = [URLQueryItem(name: "categoryId", value: String(categoryId))]
        let resource = Resource(url: Constants.Urls.getSubcategoriesByCategory(categoryId), method: .get(queryItems), modelType: SubcatResponse.self)
        let subcatResponse = try await httpClient.load(resource)
        return subcatResponse.data ?? []
    }
    
    func createCategory(name: String) async throws {
        let createCategoryRequest = CreateCategoryRequest(name: name, image: URL.randomImageURL)
        let resource = Resource(url: Constants.Urls.createCategory, method: .post(try createCategoryRequest.encode()), modelType: Category.self)
        let category = try await httpClient.load(resource)
        categories.append(category)
    }
    
 
    func deleteSubcategory(_ productId: Int) async throws -> Bool {
//        let resource = Resource(url: Constants.Urls.deleteProduct(productId), method: .delete, modelType: Bool.self)
//        return try await httpClient.load(resource)
        return true
    }
    
    func fetchProductsBy(_ categoryId: Int) async throws -> [Product] {
        let queryItems = [URLQueryItem(name: "categoryId", value: String(categoryId))]
        let resource = Resource(url: Constants.Urls.getProductsByCategory(categoryId), method: .get(queryItems), modelType: [Product].self)
        return try await httpClient.load(resource)
    }
    
    func createProduct(title: String, price: Double, description: String, categoryId: Int, images: [URL]) async throws -> Product {
        let createProductRequest = CreateProductRequest(title: title, price: price, description: description, categoryId: categoryId, images: images)
        let resource = Resource(url: Constants.Urls.createProduct, method: .post(try createProductRequest.encode()), modelType: Product.self)
        let product = try await httpClient.load(resource)
        return product
    }
    
    func deleteProduct(_ productId: Int) async throws -> Bool {
        let resource = Resource(url: Constants.Urls.deleteProduct(productId), method: .delete, modelType: Bool.self)
        return try await httpClient.load(resource)
    }
    
    func loadLocations() async throws {
        let resource = Resource(url: Constants.Urls.locations, modelType: [Location].self)
        locations = try await httpClient.load(resource)
    }
    
}
