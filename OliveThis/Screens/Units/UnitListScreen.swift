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
    
    @State var unitList: [Unit] = []
    @State private var isLoading: Bool = false
    @State private var showingAddScreen = false

    //@State private var showDetailScreen: Bool = false
    
    private func loadUnits() async {
        
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            unitList = try await store.fetchUnitsByCatSubcat(category.categoryID, subcategoryID: subcategory.subcategoryID)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    private func deleteUnit(_ indexSet: IndexSet) {
        for index in indexSet {
            
            let unit = unitList[index]
            Task {
                let isDeleted = try await store.deleteUnit(unit.unitID)
                
                if isDeleted {
                    unitList.remove(at: index)
                }
            }
        }
    }
    
    var body: some View {
        
        ZStack {
            
            if unitList.isEmpty && !isLoading {
                ContentUnavailableView("No /{subcategory.subcategoryName} have been entered - Get started by clicking on the plus sign! ", systemImage: "system.fill.circle")
            } else {
                NavigationStack {
                    List {
                        ForEach(unitList, id: \.self) { unit in
                            NavigationLink {
                                UnitDetailScreen(subcat: subcategory, unit: unit)
                            } label: {
                                UnitListCellView(unit: unit)
                            }
                        }
                        .onDelete(perform: deleteUnit)
                    }
                }
            }
        }
        .overlay(alignment: .center, content: {
            if isLoading {
                ProgressView("Loading...")
            }
        })
        .sheet(isPresented: $showingAddScreen, content: {
            NavigationStack {
                AddUnitScreen(categoryID: category.categoryID, subcat: subcategory, unitList: $unitList)
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
    UnitListScreen(
        category: Category(
            categoryID: 1,
            categoryName: "Food",
            categoryDescription: "food",
            link: nil,
            iconattribution: "",
            sortID: 1
        ),
        subcategory:  Subcategory(
           subcategoryID: 1,
           categoryID: 1,
           subcategoryName: "Restaurants",
           subcategoryDescription: "",
           link: nil, iconattribution: "",
           subcategoryNameSingular: "Restaurant",
           takesAddress: true,
           triedPhrase: "Have you eaten there?")
    ).environment(OliveThisStore(httpClient: HTTPClient()))
}


