//
//  TempScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/17/25.
//

import SwiftUI

struct TempScreen: View {
    
    @State var unit: Unit

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
