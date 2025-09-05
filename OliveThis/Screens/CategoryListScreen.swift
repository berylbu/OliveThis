//
//  CategoryListScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/31/25.
//

import SwiftUI

struct CategoryListScreen: View {
    
    @Environment(OliveThisStore.self) private var store
    @State private var isLoading: Bool = false
    @State private var showAddCategoryScreen: Bool = false
    
    private func loadCategories() async {
        
        defer { isLoading = false }
        
        do {
            isLoading = true
            try await store.loadCategories()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        
        ZStack {
            if store.categories.isEmpty && !isLoading {
                ContentUnavailableView("No products available", systemImage: "shippingbox")
            } else {
                List(store.categories) { category in
                    NavigationLink {
                        ProductListScreen(category: category)
                    } label: {
                        CategoryCellView(category: category)
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
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Category") {
                    showAddCategoryScreen = true
                }
            }
        })
        .sheet(isPresented: $showAddCategoryScreen, content: {
            NavigationStack {
                AddCategoryScreen()
            }
        })
        .task {
            await loadCategories()
        }
        .navigationTitle("Categories")
    }
}

#Preview {
    NavigationStack {
        CategoryListScreen()
    }.environment(OliveThisStore(httpClient: HTTPClient()))
}

struct CategoryCellView: View {
    
    let category: Category
    
    var body: some View {
        HStack {
            if category.link == nil {
                Image(systemName: "folder")
                    .foregroundColor(.gray)
            }
            else {
                let imageURL = category.link!
                AsyncImage(url: imageURL) { img in
                    img.resizable()
                        .frame(width: 75, height: 75)
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                } placeholder: {
                    ImagePlaceholderView()
                }
            }
            
            Text(category.categoryName)
        }
    }
}
