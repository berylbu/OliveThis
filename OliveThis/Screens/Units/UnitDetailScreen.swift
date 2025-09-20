//
//  UnitDetailScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/20/25.
//

import SwiftUI

struct UnitDetailScreen: View {
    
    @State var unit: Unit
    
    var body: some View {
        Text(unit.name)
    }
}

#Preview {
//    UnitDetailScreen()
}
