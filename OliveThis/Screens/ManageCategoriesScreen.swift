//
//  AddCategoryScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/31/25.
//

import SwiftUI

struct ManageCategoriesScreen: View {
    
    @Environment(OliveThisStore.self) private var store
    @State private var isLoading: Bool = false
    
    @State private var name: String = ""
    @Environment(\.dismiss) private var dismiss
    
    private func saveCategories() async {
        
    }
    
    private func deleteCategory() async {
        
    }
    
    private func loadUserCategories() async {
        
        defer { isLoading = false }
        
        do {
            isLoading = true
            try await store.loadUserCategories()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationStack {
//            List {
//                ForEach(books) { book in
//                    NavigationLink(value: book) {
//                        HStack {
//                           EmojiRatingView(rating: book.rating)
//                                .font(.largeTitle)
//                            VStack(alignment: .leading) {
//                                Text(book.title)
//                                    .font(.headline)
//                                
//                                Text(book.author)
//                                    .foregroundStyle(.secondary)
//                            }
//                        }
//                    }
//                }
//                .onDelete(perform: deleteBook)
//            }
//            .navigationTitle(Text("Bookworm"))
//            .navigationDestination(for: Book.self) { book in DetailView(book: book)
//            }
//            
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    EditButton()
//                }
//                
//                ToolbarItem(placement: .topBarTrailing) {
//                    
//                    Button("Add Book", systemImage: "plus") {
//                        showingAddScreen.toggle()
//                    }
//                }
//            }
//            .sheet(isPresented: $showingAddScreen, content: { AddBookView() })
//        }
//        .task {
//            await loadUserCategories()
//        }
//    }
//    
//    func deleteBook(at offsets: IndexSet) {
//        for offset in offsets {
//            let category = books[offset]
//            modelContext.delete(book)
        }
    }
}

#Preview {
    NavigationStack {
        ManageCategoriesScreen()
    }.environment(OliveThisStore(httpClient: HTTPClient()))
}
