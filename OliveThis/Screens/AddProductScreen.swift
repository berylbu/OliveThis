//
//  AddProductScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/4/25.
//

import SwiftUI

struct AddProductScreen: View {
    
    @State private var title: String = ""
    @State private var price: Double?
    @State private var description: String = ""
    @Environment(\.dismiss) private var dismiss
    @Environment(OliveThisStore.self) private var store
    
    @State private var selectedCategoryId: Int
    let onSave: (Product) -> Void
    
    init(selectedCategoryId: Int, onSave: @escaping (Product) -> Void) {
        self.selectedCategoryId = selectedCategoryId
        self.onSave = onSave
    }
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace && !description.isEmptyOrWhitespace && price != nil && price! > 0
    }
    
    private func saveProduct() async {
        
        guard let price = price else {
            return
        }
        
        do {
            let newProduct = try await store.createProduct(title: title, price: price, description: description, categoryId: selectedCategoryId, images: [URL.randomImageURL])
            
            onSave(newProduct)
            dismiss()
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    var body: some View {
        Form {
            Picker("Select a category", selection: $selectedCategoryId) {
                ForEach(store.categories) { category in
                    Text(category.categoryName)
                        .tag(category.id)
                }
            }.pickerStyle(.automatic)
            
            TextField("Title", text: $title)
            TextField("Price", value: $price, format: .number)
                .keyboardType(.decimalPad)
            TextEditor(text: $description)
                .frame(height: 100)
            
        }.task {
            do {
                try await store.loadCategories()
            } catch {
                print(error.localizedDescription)
            }
        }
        .toolbar(content: {
                   ToolbarItem(placement: .topBarLeading) {
                       Button("Cancel") {
                           dismiss()
                       }
                   }
                   
                   ToolbarItem(placement: .topBarTrailing) {
                       Button("Save Product") {
                           Task { await saveProduct() }
                       }.disabled(!isFormValid)
                   }
               })
    }
}

#Preview {
    NavigationStack {
        AddProductScreen(selectedCategoryId: 79, onSave: { _ in })
    }.environment(OliveThisStore(httpClient: HTTPClient()))
}
