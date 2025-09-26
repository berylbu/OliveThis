//
//  UnitCellView.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/26/25.
//

import SwiftUI

struct UnitCellView: View {
    
    let unit: Unit
    let subcat: Subcategory
    
    
    var body: some View {
        
        VStack {
            
            Text(unit.name.uppercased())
                .fontWeight(.black)
                .padding(8)
                .foregroundStyle(.white)
                .background(.black.opacity(0.7))
                .clipShape(Capsule())
        
            Text(unit.genre ?? "")
                .font(.title)
                .foregroundStyle(.secondary)
            
            Text(unit.notes ?? "")
                .padding()
            
            RatingView(rating: .constant(unit.rating))
                .font(.largeTitle)
            
            if subcat.takesAddress {
                Section {
                    VStack(alignment: .leading) {
                        
                        Text(unit.address ?? "")
                            .padding()
                        
                        if unit.telephoneNumber != nil {
                            Text(unit.telephoneNumber ?? "").padding()
                        }
                        if unit.telephoneNumber2 != nil {
                            Text(unit.telephoneNumber2 ?? "").padding()
                        }

                        if unit.longitude != nil && unit.latitude != nil {
                            MapDetailView(latitude: unit.latitude ?? 0, longitude: unit.longitude ?? 0, locationName: unit.name).frame(height: 200)
                                
                        }
                    }
                }
            }
            else {
                if unit.telephoneNumber != nil {
                    Text(unit.telephoneNumber ?? "").padding()
                }
                if unit.telephoneNumber2 != nil {
                    Text(unit.telephoneNumber2 ?? "").padding()
                }
            }
            
            if let url = URL(string: unit.webLink ?? "") {
                Link("Website: " + (unit.webLink ?? ""), destination: url)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
            }
        }
    }
}
#Preview {
    UnitCellView( unit: Unit(
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
            longitude: 118.44602),
        subcat:  Subcategory(
            subcategoryID: 1,
            categoryID: 1,
            subcategoryName: "Restaurant",
            subcategoryDescription: "",
            link: nil, iconattribution: "",
            subcategoryNameSingular: "Restaurant",
            takesAddress: true,
            triedPhrase: "Have you eaten there?"))
}
