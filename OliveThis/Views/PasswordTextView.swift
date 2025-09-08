//
//  PasswordTextView.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/6/25.
//

import SwiftUI

struct PasswordTextView: View {
    @Binding var text: String
    @State var isSecure: Bool = true
    var titleKey: String
    
    var body: some View {
        HStack() {
            if isSecure {
                SecureField(titleKey, text: $text)
                    .textContentType(.newPassword)
            } else {
                TextField(titleKey, text: $text)
                    .textContentType(.newPassword)
           }
            Button(action: {
                isSecure.toggle()
            }, label: {
                Image(systemName: isSecure ? "eye" : "eye.slash")
                    .foregroundColor(.black)
            })
        }//.padding(.horizontal, 8)
    }
}

#Preview {
    PasswordTextView(text: .constant("12345678"), titleKey: "Enter password")
}
