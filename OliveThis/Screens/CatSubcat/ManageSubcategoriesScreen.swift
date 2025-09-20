//
//  ManageSubcategories.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/11/25.
//

import SwiftUI

struct ManageSubcategoriesScreen: View {
    
    let categoriesAll: CategoriesAll

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    NavigationStack {
        ManageSubcategoriesScreen(categoriesAll: CategoriesAll(categoryID: 1, categoryName: "Test", isUsed: false, sortID: 0))
    }.environment(OliveThisStore(httpClient: HTTPClient()))
}
