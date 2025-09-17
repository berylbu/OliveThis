//
//  TestScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/16/25.
//

import SwiftUI

struct SelectCategoriesScreen: View {
    
    @Environment(OliveThisStore.self) private var store
    @State private var isLoading: Bool = false
    @State private var showManageSubCategoriesScreen: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var catAll: [CategoriesAll] = []
    
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
        
        ZStack {
            if store.categoriesAll.isEmpty && !isLoading {
                ContentUnavailableView("No Categories available", systemImage: "shippingbox")
            } else {
                VStack {
                    Text("Select your categories")
                        .font(.headline)
                    NavigationView {
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
        }
        .task {
            await loadUserCategoriesAll()
        }

    }
}

#Preview {
    NavigationStack {
        SelectCategoriesScreen()
    }.environment(OliveThisStore(httpClient: HTTPClient()))
}
