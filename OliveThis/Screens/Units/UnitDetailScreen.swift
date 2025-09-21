//
//  UnitDetailScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/20/25.
//

import SwiftUI

struct UnitDetailScreen: View {
    
    @State var unit: Unit
    
    var body: some View {
        VStack {
            Text(unit.name)
                .font(.largeTitle)
            Text(unit.address ?? "")
            Text(unit.genre ?? "")
            RatingView(rating: .constant(unit.rating))
                .font(.largeTitle)
            Text(unit.notes ?? "")
       }
        .navigationTitle(unit.name)
            .font(.headline)
            .padding()
    }
}

#Preview {
    UnitDetailScreen(unit: Unit(
          unitID: 1,
          categoryID: 1,
          subcategoryID: 1,
          appUserID: "userid",
          genre: "1/1/2020",
          createdDate: "1/1/2020",
          lastEditedDate: "1/1/2020",
          userTried: false,
          rating: 1,
          name: "In N Out",
          notes: "Owner is an asshole"
      ))
}
