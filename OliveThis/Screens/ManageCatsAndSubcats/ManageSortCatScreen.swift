//
//  TestScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/16/25.
//

import SwiftUI

struct ManageSortCatScreen: View {
    
    enum TopMenuOption: String, CaseIterable {
        case Viewing
        case Editing
    }
    
    @Environment(OliveThisStore.self) private var store
    @Environment(\.editMode) private var editMode
    
    @State private var isLoading: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var catsUser: [Category] = []
    @State private var screenTitle: String = "Sort your category list"
    
    @State private var currentAction: TopMenuOption = .Viewing
    

    private func loadUserCategoriesAll() async {
        
        defer { isLoading = false }
        
        do {
            isLoading = true
            try await store.loadUserCategories()
            catsUser = store.categories

        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        
        if currentAction == .Viewing || currentAction == .Editing {
            
            ZStack {
                if store.categories.isEmpty && !isLoading {
                    ContentUnavailableView("No Categories available", systemImage: "shippingbox")
                } else {
                    VStack {
                        Text(screenTitle)
                            .font(.headline)
                        
                        List {
                            ForEach($catsUser, id: \.self) { $item in
                                Text(item.categoryName)
                            }
                            .onMove(perform: move)
                        }
                    }
                }
            }
            .environment(\.editMode, currentAction == .Editing ? .constant(.active) : .constant(.inactive))
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
                                await saveCats(catsUser)
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
    
    func move(from source: IndexSet, to destination: Int) {
        catsUser.move(fromOffsets: source, toOffset: destination)
    }
    
    func saveCats(_ data: [Category]) async {
        
        var counter = 1
        var catsRequest: [UserCatUpdateRequest] = []

        for cat in data {
            let catRequest: UserCatUpdateRequest = .init(categoryID: cat.categoryID, sortID: counter)
            catsRequest.append(catRequest)
            counter += 1
            print(cat.categoryName)
        }
    
        do {
            var isSuccess: Bool = false
            isSuccess = try await store.updateUserCategories (catsRequest)
            if (isSuccess) {
                await loadUserCategoriesAll()
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
        ManageSortCatScreen()
    }.environment(OliveThisStore(httpClient: HTTPClient()))
}

