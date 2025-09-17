//
//  ManageCategoryScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/31/25.
//

import SwiftUI

struct ManageCategoriesScreen: View {
    
    @Environment(OliveThisStore.self) private var store
    @State private var isLoading: Bool = false
    @State private var showManageSubCategoriesScreen: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var catAll: [CategoriesAll] = []
    @State private var topMenuOption: String = "Save categories"
    @State private var screenTitle: String = "Select your categories"

    private func loadUserCategoriesAll() async {
        
        defer { isLoading = false }
        
        do {
            isLoading = true
            try await store.loadUserCategoriesAll()
            catAll = store.categoriesAll

        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        
        TabView {
            Tab {
                ZStack {
                    if store.categoriesAll.isEmpty && !isLoading {
                        ContentUnavailableView("No Categories available", systemImage: "shippingbox")
                    } else {
                        VStack {
                            Text(screenTitle)
                                .font(.headline)
                            
                        List {

                                ForEach($catAll, id: \.self) { $item in
                                    HStack {
                                        Image(systemName: $item.isUsed.wrappedValue ? "checkmark.square.fill" : "square")
                                            .foregroundColor($item.isUsed.wrappedValue ? .blue : .gray)
                                        Text(item.categoryName)

                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        $item.isUsed.wrappedValue.toggle()
                                    }
                                }
                            }
                        }
                    }
                }
                .overlay(alignment: .center, content: {
                    if isLoading {
                        ProgressView("Loading...")
                    }
                })
                .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(topMenuOption) {
                            Task {
                                await saveCats(catAll)
                            }
                        }
                    }
                })
                .task {
                    await loadUserCategoriesAll()
                }
            } label: {
                Label("Select Categories", systemImage: "square.grid.2x2")
            }
            
          
            Tab {
                NavigationStack {
                    LocationsScreen()
                }
            } label: {
                Label("Order Categories", systemImage: "map")
            }
            
            Tab {
                NavigationStack {
                    ProfileScreen()
                }
            } label: {
                Label("Subcategories", systemImage: "person.crop.circle")
            }
        }
        
        
    }
    
    
    func saveCats(_ data: [CategoriesAll]) async {
        
        var counter = 1
        var catsRequest: [UserCatUpdateRequest] = []

        for cat in data {
            if (cat.isUsed) {
                let catRequest: UserCatUpdateRequest = .init(categoryID: cat.categoryID, sortID: counter)
                catsRequest.append(catRequest)
                counter += 1
                print(cat.categoryName)
            }
        }
    
        do {
            var isSuccess: Bool = false
            isSuccess = try await store.updateUserCategories (catsRequest)
            if (isSuccess) {
                
                await loadUserCategoriesAll()
                topMenuOption = ""
                screenTitle = "Your categories have been saved."
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }

}

#Preview {
    NavigationStack {
        ManageCategoriesScreen()
    }.environment(OliveThisStore(httpClient: HTTPClient()))
}
