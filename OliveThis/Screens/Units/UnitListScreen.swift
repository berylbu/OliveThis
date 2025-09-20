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
    @State private var units: [Unit] = []
    @State private var isLoading: Bool = false
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
    
    var body: some View {
        
        ZStack {
            
            if units.isEmpty && !isLoading {
                ContentUnavailableView("No items have been entered - Get Started! ", systemImage: "system.fill.circle")
            } else {
                List(units) { unit in
                    NavigationLink(destination: UnitDetailScreen(unit: unit)) {
                        UnitCellView(unit: unit)
                    }
                }.refreshable {
                    await loadUnits()
                }
            }
        }
        .overlay(alignment: .center, content: {
            if isLoading {
                ProgressView("Loading...")
            }
        })
        .task {
            await loadUnits()
        }
        .navigationTitle(subcategory.subcategoryName)
    }
}

#Preview {
    NavigationStack {
        CategoryListScreen()
    }.environment(OliveThisStore(httpClient: HTTPClient()))
}

struct UnitCellView: View {
    
    let unit: Unit
    
    var body: some View {
        HStack {
            Text(unit.name)
        }
    }
}
