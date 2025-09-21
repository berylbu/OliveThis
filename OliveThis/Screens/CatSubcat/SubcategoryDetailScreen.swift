//
//  SubcategoryDetailScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/5/25.
//

import SwiftUI

struct SubcategoryDetailScreen: View {
    
    let subcategory: Subcategory
    
    var body: some View {
        Text("Subcategory Detail Screen")
        Text(subcategory.subcategoryName)
    }
}

#Preview {
    NavigationStack {
        SubcategoryDetailScreen(subcategory: Subcategory.preview)
    }
}
