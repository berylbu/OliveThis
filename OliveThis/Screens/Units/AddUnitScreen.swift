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
        
    @State private var personFirstName: String = ""
    @State private var personLastName: String = ""
    @State private var secondPersonFirstName: String  = ""
    @State private var secondPersonLastName: String = ""
    
    @State private var address1: String = ""
    @State private var address2: String = ""
    @State private var city: String = ""
    @State private var region: String = ""
    @State private var postalCode: String = ""
    @State private var telephoneNumber: String = ""
    @State private var telephoneNumber2: String = ""
    @State private var country: String = ""
    
    @State private var webLink: String = ""
    @State private var imageLink: String = ""
    
    @State private var recByFirstName: String = ""
    @State private var recByLastName: String = ""
    @State private var recByAppUserID: String = ""
    
    
    
    @Environment(\.dismiss) private var dismiss
    @Environment(OliveThisStore.self) private var store
    

    private var isFormValid: Bool {
        !name.isEmptyOrWhitespace
            && !name.isEmptyOrWhitespace
            && genre != nil
    }
    
    private func saveUnit() async {
        
        do {
            let createUnitRequest = CreateUnitRequest(categoryID: categoryID, subcategoryID: subcat.subcategoryID, genre: genre, userTried: userTried, rating: rating, name: name, notes: note, personFirstName: personFirstName, personLastName: personLastName, secondPersonFirstName: secondPersonFirstName, secondPersonLastName: secondPersonLastName, address1: address1, address2: address2, city: city, region: region, postalCode: postalCode, telephoneNumber: telephoneNumber, telephoneNumber2: telephoneNumber2, webLink: webLink, imageLink: imageLink, recByFirstName: recByFirstName, recByLastName: recByLastName, recByAppUserID: recByAppUserID)
            
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
            
            if subcat.takesAddress {
                Section {
                    VStack(alignment: .leading) {
//                        Picker("Country", selection: $region) {
//                            ForEach(store.regions, id: \.self) { region in
//                                Text(region)
//                            }
//                        }
                        TextField("Address Line 1", text: $address1)
                        TextField("Address Line 2", text: $address2)
                        TextField("City", text: $city)
//                        Picker("Region", selection: $region) {
//                            ForEach(store.regions, id: \.self) { region in
//                                Text(region)
//                            }
//                        }
                    }
                }
                Section {
                    VStack(alignment: .leading) {
                        TextField("Telephone", text: $telephoneNumber)
                    }
                }
                
                Section {
                    //suggest from map view
                    MapView()
                }
            }
            
        }
        .navigationTitle("Add a \(subcat.subcategoryNameSingular ?? "temp")")
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

