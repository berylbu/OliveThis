//
//  UnitDetailScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/20/25.
//

import SwiftUI
import MapKit

struct UnitDetailScreen: View {
    
    let subcat: Subcategory
    @State var unit: Unit
    
    @State private var showingDeleteAlert = false

    var body: some View {
        
        ScrollView {
            UnitCellView(unit: unit, subcat: subcat)
        }
        .scrollBounceBehavior(.basedOnSize)
        .alert("Delete", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteUnit)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
     
        .toolbar {
            Button("Delete?", systemImage: "trash") {
                showingDeleteAlert = true
            }
        }
        .toolbar {
            Button("Edit", systemImage: "pencil.line") {
                showingDeleteAlert = true
            }
        }
       
        .padding()
    }
    
    func deleteUnit() {
        
    }
}

#Preview {
    UnitDetailScreen(
        subcat: Subcategory(
            subcategoryID: 1,
            categoryID: 1,
            subcategoryName: "Restaurant",
            subcategoryDescription: "",
            link: nil,
            iconattribution: "",
            subcategoryNameSingular: "Restaurant",
            takesAddress: true,
            triedPhrase: "Have you eaten there?"),
        unit: Unit(
            unitID: 1,
            categoryID: 1,
            subcategoryID: 1,
            appUserID: "userid",
            genre: "burger",
            createdDate: "1/1/2020",
            lastEditedDate: "1/1/2020",
            userTried: false,
            rating: 1,
            name: "In N Out",
            notes: "Owner is an asshole",
            latitude: 33.99265,
            longitude: 118.44602)
    )
}

