//
//  TestScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/16/25.
//

import SwiftUI

struct ManageSelectCatScreen: View {
    
    enum TopMenuOption: String, CaseIterable {
        case Viewing
        case Editing
    }
    
    @Environment(OliveThisStore.self) private var store
    @State private var isLoading: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var catAll: [CategoriesAll] = []
    @State private var screenTitle: String = "Select which categories to use"
    
    @State private var currentAction: TopMenuOption = .Viewing
    

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
        
        if currentAction == .Viewing || currentAction == .Editing {
            
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
                                    if currentAction == .Editing {  $item.isUsed.wrappedValue.toggle() }
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
                   if currentAction == .Viewing {
                        Button("Back") {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if currentAction == .Editing {
                        Button("Cancel") {
                            currentAction = .Viewing
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if currentAction == .Editing{
                        Button("Save") {
                            Task {
                                await saveCats(catAll)
                            }
                            currentAction = .Viewing
                        }
                    }
                    else if currentAction == .Viewing {
                        Button("Edit") {
                            currentAction = .Editing
                            screenTitle = "Editing your selected categories"
                        }
                    }
                }
              
            })
            .task {
                await loadUserCategoriesAll()
            }
        }
    }
    
    func saveCats(_ data: [CategoriesAll]) async {
        
        var catsRequest: [UserCatUpdateRequest] = []

        for cat in data {
            if (cat.isUsed) {
                let catRequest: UserCatUpdateRequest = .init(categoryID: cat.categoryID, sortID: cat.sortID)
                catsRequest.append(catRequest)
                print(cat.categoryName)
            }
        }
        
    
        do {
            var isSuccess: Bool = false
            isSuccess = try await store.updateUserCategories (catsRequest)
            if (isSuccess) {
                try await store.loadUserCategories()
                screenTitle = "Your categories have been saved."
                currentAction = .Viewing
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }

}

#Preview {
    NavigationStack {
        ManageSelectCatScreen()
    }.environment(OliveThisStore(httpClient: HTTPClient()))
}

