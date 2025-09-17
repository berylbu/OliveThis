//
//  Toggles.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/11/25.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? .accentColor : .gray)
                configuration.label
            }
        }
    }
}

struct TempView: View {
    
    @State private var items = [
        "Task 1": false,
        "Task 2": true,
        "Task 3": false
    ]
    
    var body: some View {
        List {
            ForEach(items.keys.sorted(), id: \.self) { key in
                Toggle(isOn: Binding(
                    get: { self.items[key] ?? false},
                    set: { self.items[key] = $0 }
                )) {
                    Text(key)
                }
                .toggleStyle(CheckboxToggleStyle())
            }
        }
        //.toggleStyle(CheckboxToggleStyle())
    }
}

#Preview {
    TempView()
}
