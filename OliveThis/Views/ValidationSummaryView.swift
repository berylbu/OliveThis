//
//  ValidationSummaryView.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/30/25.
//

import SwiftUI

struct ValidationSummaryView: View {
    
    let errors: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(errors, id: \.self) { error in
                HStack(alignment: .top) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(error)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .padding()
        .background(Color.red.opacity(0.05))
        .cornerRadius(8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ValidationSummaryView(errors: [
        "Name cannot be empty.",
        "Password must be at least 8 characters.",
        "Email format is invalid."
    ])
    .padding()
}
