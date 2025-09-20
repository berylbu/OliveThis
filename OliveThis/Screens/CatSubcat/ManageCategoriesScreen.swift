//
//  ManageCategoryScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/31/25.
//

import SwiftUI

struct ManageCategoriesScreen: View {
    enum TopMenuOption: String, CaseIterable {
        case SelectedCats
        case SortCats
        case CatsToSubcats
    }
    
    @Environment(OliveThisStore.self) private var store
    @State private var isLoading: Bool = false
    @State private var showManageSubCategoriesScreen: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var catAll: [CategoriesAll] = []
    @State private var screenTitle: String = "Your category list"
    
    @State private var currentAction: TopMenuOption = .SelectedCats

    var body: some View {
        NavigationStack {
            if (currentAction == .SelectedCats) {
                ManageSelectCatScreen()
            }
            else if (currentAction == .SortCats) {
                ManageSortCatScreen()
            }
            else if (currentAction == .CatsToSubcats) {
                
            }
        }
        .toolbar(content: {
            if (currentAction != .SelectedCats) {
                ToolbarItem(placement: .bottomBar) {
                    Button("Select Categories") {
                        currentAction = .SelectedCats
                    }
                }
            }
            if (currentAction != .SortCats) {
                ToolbarItem(placement: .bottomBar) {
                    Button("Sort Categories") {
                        currentAction = .SortCats
                    }
                }
            }
            if (currentAction != .CatsToSubcats) {
                ToolbarItem(placement: .bottomBar) {
                    Button("Manage Subcategories") {
                        currentAction = .CatsToSubcats
                    }
                }
            }
        })
    }
}

#Preview {
    NavigationStack {
        ManageCategoriesScreen()
    }.environment(OliveThisStore(httpClient: HTTPClient()))
}
