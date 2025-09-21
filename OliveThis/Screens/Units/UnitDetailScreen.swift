//
//  UnitDetailScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/20/25.
//

import SwiftUI

struct UnitDetailScreen: View {
    
    @State var unit: Unit
    @State private var showingDeleteAlert = false

    var body: some View {
        
        ScrollView {
            UnitCellView(unit: unit)
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
    UnitDetailScreen(unit: Unit(
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
          notes: "Owner is an asshole"
      ))
}

struct UnitCellView: View {
    
    let unit: Unit
    
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
            
        }
    }
}

