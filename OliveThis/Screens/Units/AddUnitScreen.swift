//
//  AddUnit.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/21/25.
//

import SwiftUI

struct AddUnitScreen: View {
    
    let categoryID: Int
    let subcat: Subcategory
    @Binding var units: [Unit]
    
    @State private var name: String = ""
    @State private var genre: String? = ""
    @State private var note: String = ""
    @State private var userTried: Bool = false
    @State private var rating: Int = 0
    
    @Environment(\.dismiss) private var dismiss
    @Environment(OliveThisStore.self) private var store
    
//    init(categoryID: Int, subcategoryID: Int, subcategoryName: String) {
//        self.categoryID = categoryID
//        self.subcat = Subcategory(categoryID: categoryID, subcategoryID: subcategoryID, subcategoryName: subcategoryName, triedPhrase = triedPhrase, takesAddress: takesAddress)
//    }
    
//    private func loadUnits() async {
//        do {
//            units = try await store.fetchUnitsByCatSubcat(categoryID, subcategoryID: subcat.subcategoryID)
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//    }
    
    private var isFormValid: Bool {
        !name.isEmptyOrWhitespace
            && !name.isEmptyOrWhitespace
            && genre != nil
    }
    
    private func saveUnit() async {
        
        do {
            let createUnitRequest = CreateUnitRequest(categoryID: categoryID, subcategoryID: subcat.subcategoryID, genre: genre, userTried: userTried, rating: rating, name: name, notes: note, personFirstName: "", personLastName: "", secondPersonFirstName: "", secondPersonLastName: "", address1: "", address2: "", city: "", region: "", postalCode: "", telephoneNumber: "", telephoneNumber2: "", webLink: "", imageLink: "", recByFirstName: "", recByLastName: "", recByAppUserID: "")
            
            units = try await store.createUnit(createUnitRequest)
             
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
                Toggle(isOn: $userTried) {
                            Text("Have you tried it?")
                        }
                        .toggleStyle(CheckboxToggleStyle())
            }
            
            if userTried {
                Section("Write a review"){
                    TextEditor(text: $note)
                    RatingView(rating: $rating)
                }
            }
            
        }
        .navigationTitle("Add a \(subcat.subcategoryNameSingular ?? "temp")")
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
                   dismiss()
               }.disabled(!isFormValid)
           }
        }
    }
}

#Preview {
//    NavigationStack {
//        AddUnitScreen(categoryID: 1, subcat: Subcategory.preview, units: units)
//    }.environment(OliveThisStore(httpClient: HTTPClient()))
    
}

