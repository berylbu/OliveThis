//
//  Units.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/19/25.
//

import SwiftUI

struct UnitListScreen: View {
    
    let category: Category
    let subcategory: Subcategory
    
    @Environment(OliveThisStore.self) private var store
    @State var units: [Unit] = []
    @State private var isLoading: Bool = false
    @State private var showingAddScreen = false

    //@State private var showDetailScreen: Bool = false
    
    private func loadUnits() async {
        
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            units = try await store.fetchUnitsByCatSubcat(category.categoryID, subcategoryID: subcategory.subcategoryID)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    private func deleteUnit(_ indexSet: IndexSet) {
        for index in indexSet {
            
            let unit = units[index]
            Task {
                let isDeleted = try await store.deleteUnit(unit.unitID)
                
                if isDeleted {
                    units.remove(at: index)
                }
            }
        }
    }
    
    var body: some View {
        
        ZStack {
            
            if units.isEmpty && !isLoading {
                ContentUnavailableView("No items have been entered - Get Started! ", systemImage: "system.fill.circle")
            } else {
                NavigationStack {
                    List {
                        ForEach(units, id: \.self) { unit in
                            NavigationLink {
                                UnitDetailScreen(unit: unit)
                            } label: {
                                UnitListCellView(unit: unit)
                            }
                        }
                        .onDelete(perform: deleteUnit)
                    }
                }
//                List(units) { unit in
//                    NavigationLink {
//                        UnitDetailScreen(unit: unit)
//                    } label: {
//                        UnitListCellView(unit: unit)
//                    }
//                }.refreshable {
//                    await loadUnits()
//                }
//                .onDelete(perform: deleteUnit)
            }
        }
        .overlay(alignment: .center, content: {
            if isLoading {
                ProgressView("Loading...")
            }
        })
        .sheet(isPresented: $showingAddScreen, content: {
            NavigationStack {
                AddUnitScreen(categoryID: category.categoryID, subcat: subcategory, units: $units)
            }
        })
        .task {
            await loadUnits()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add", systemImage: "plus") {
                    showingAddScreen.toggle()
                }
            }
        }
        .navigationTitle(subcategory.subcategoryName)
    }
}

#Preview {
    CategoryListScreen()
}

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
