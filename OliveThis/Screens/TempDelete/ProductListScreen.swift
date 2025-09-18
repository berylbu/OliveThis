//
//  ProductListScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/4/25.
//

import SwiftUI

struct ProductListScreen: View {
    
    let category: Category
    
    @Environment(OliveThisStore.self) private var store
    @State private var products: [Product] = []
    @State private var isLoading: Bool = false
    @State private var showAddProductScreen: Bool = false
    
    private func loadProducts() async {
        
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            products = try await store.fetchProductsBy(category.id)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteProduct(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let product = products[index]
            Task {
                let isDeleted = try await store.deleteProduct(product.id)
                if isDeleted {
                    products.remove(atOffsets: indexSet)
                }
            }
        }
    }
    
    var body: some View {
        
        ZStack {
            if products.isEmpty && !isLoading {
                ContentUnavailableView("No products available", systemImage: "shippingbox")
            } else {
                List {
                    ForEach(products) { product in
                        NavigationLink {
                            ProductDetailScreen(product: product)
                        } label: {
                            ProductCellView(product: product)
                        }
                    }.onDelete(perform: deleteProduct)
                }.refreshable {
                    await loadProducts()
                }
            }
        }
        .overlay(alignment: .center, content: {
            if isLoading {
                ProgressView("Loading...")
            }
        })
        .sheet(isPresented: $showAddProductScreen, content: {
            NavigationStack {
                AddProductScreen(selectedCategoryId: category.id) { product in
                    products.append(product)
                }
            }
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Product") {
                    showAddProductScreen = true
                }
            }
        }
        .task {
            await loadProducts()
        }.navigationTitle(category.categoryName)
    }
}

struct ProductCellView: View {
    
    let product: Product
    
    var body: some View {
        HStack {
            AsyncImage(url: product.images.first) { img in
                img.resizable()
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
            } placeholder: {
                ImagePlaceholderView()
            }
            
            Text(product.title)
        }
    }
}

#Preview {
//    NavigationStack {
//        ProductListScreen(category: Category(categoryid: 79, name: "Shoes", image: URL.randomImageURL))
//    }.environment(OliveThisStore(httpClient: HTTPClient()))
}
