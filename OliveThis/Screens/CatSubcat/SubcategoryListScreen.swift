//
//  SubcategoryListScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/5/25.
//

import SwiftUI

struct SubcategoryListScreen: View {
    
    let category: Category
    
    @Environment(OliveThisStore.self) private var store
    @State private var subcategories: [Subcategory] = []
    @State private var isLoading: Bool = false
    
    private func loadSubcategories() async {
        
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            subcategories = try await store.fetchSubcategoriesByCat(category.id)
        } catch {
            print(error.localizedDescription)
        }
    }
    
//    private func deleteSubcategory(_ indexSet: IndexSet) {
//        indexSet.forEach { index in
//            let subcategory = subcategories[index]
//            Task {
//                let isDeleted = try await store.deleteSubcategory(subcategory.id)
//                if isDeleted {
//                    subcategories.remove(atOffsets: indexSet)
//                }
//            }
//        }
//    }
    
    var body: some View {
        
        ZStack {
            if subcategories.isEmpty && !isLoading {
                ContentUnavailableView("No subcategories available", systemImage: "shippingbox")
            } else {
                List {
                    ForEach(subcategories) { subcat in
                        NavigationLink {
                            UnitListScreen(category: category, subcategory: subcat)
                        } label: {
                            SubcatCellView(subcategory: subcat)
                        }
                    }
                }.refreshable {
                    await loadSubcategories()
                }
            }
        }
        .overlay(alignment: .center, content: {
            if isLoading {
                ProgressView("Loading...")
            }
        })
        .task {
            await loadSubcategories()
        }.navigationTitle(category.categoryName)
    }
}

struct SubcatCellView: View {
    
    let subcategory: Subcategory
    
    var body: some View {
        HStack {
//            if subcategory.link == nil {
//                Image(systemName: "folder")
//                    .foregroundColor(.gray)
//            }
//            else {
//                let imageURL = subcategory.link!
//                AsyncImage(url: imageURL) { img in
//                    img.resizable()
//                        .frame(width: 75, height: 75)
//                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
//                } placeholder: {
//                    ImagePlaceholderView()
//                }
//            }
            
            Text(subcategory.subcategoryName)
        }
    }
}

#Preview {
    NavigationStack {
        SubcategoryListScreen(category: Category(categoryID: 1, categoryName: "Test", categoryDescription: "Test", link: URL.randomImageURL, iconattribution: "", sortID: 0))
    }.environment(OliveThisStore(httpClient: HTTPClient()))
}
