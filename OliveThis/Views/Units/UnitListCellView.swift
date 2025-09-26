//
//  UnitListCellView.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/26/25.
//

import SwiftUI

struct UnitListCellView: View {
    
    let unit: Unit
    
    var body: some View {
        HStack {
           EmojiRatingView(rating: unit.rating)
                .font(.largeTitle)
            VStack(alignment: .leading) {
                Text(unit.name)
                    .font(.headline)
                
                Text(unit.genre ?? "" )
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    UnitListCellView(unit: Unit(
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
        longitude: 118.44602))
}
