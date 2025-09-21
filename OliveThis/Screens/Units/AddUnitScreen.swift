//
//  AddUnit.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/21/25.
//

import SwiftUI

struct AddUnitScreen: View {
    
    @State private var categoryID: Int
    @State private var subcategoryID: Int

    @State private var name: String = ""
    @State private var genre: String? = ""
    @State private var note: String = ""
    @State private var userTried: Bool = false
    @State private var rating: Int = 0
    
    @Environment(\.dismiss) private var dismiss
    @Environment(OliveThisStore.self) private var store
    
    
    
    init(categoryID: Int, subcategoryID: Int) {
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
    }
    
    private var isFormValid: Bool {
        !name.isEmptyOrWhitespace
            && !name.isEmptyOrWhitespace
            && genre != nil
    }
    
    private func saveUnit() async {
        
        do {
            let createUnitRequest = CreateUnitRequest(categoryID: categoryID, subcategoryID: subcategoryID, genre: genre, userTried: userTried, rating: rating, name: name, notes: note, personFirstName: "", personLastName: "", secondPersonFirstName: "", secondPersonLastName: "", address1: "", address2: "", city: "", region: "", postalCode: "", telephoneNumber: "", telephoneNumber2: "", webLink: "", imageLink: "", recByFirstName: "", recByLastName: "", recByAppUserID: "")
            
            _ = try await store.createUnit(createUnitRequest)
             
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    var body: some View {
        Form {
//            Picker("Select a type", selection: $categoryID) {
//                ForEach(store.categories) { category in
//                    Text(category.categoryName)
//                        .tag(category.id)
//                }
//            }.pickerStyle(.automatic)
            
            Section {
                TextField("Name", text: $name)
                Text("Notes:").font(.headline)
                TextEditor(text: $note)
                    .frame(height: 100)
            }
            
        }
//        .task {
//            do {
//                try await store.loadCategories()
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
        .toolbar {
           ToolbarItem(placement: .topBarLeading) {
               Button("Cancel") {
                   dismiss()
               }
           }
           
           ToolbarItem(placement: .topBarTrailing) {
               Button("Save") {
                   Task { await saveUnit() }
               }.disabled(!isFormValid)
           }
        }
    }
}

#Preview {
    CategoryListScreen()
    
}

