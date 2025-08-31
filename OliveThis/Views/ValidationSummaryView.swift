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
       if errors.isEmpty {
           EmptyView() // or Text("No validation errors")
       } else {
           VStack(alignment: .leading, spacing: 8) {
               Text("Validation Errors")
                   .font(.headline)
                   .foregroundColor(.red)
               
               ForEach(errors, id: \.self) { error in
                   HStack(alignment: .top) {
                       Image(systemName: "exclamationmark.triangle.fill")
                           .foregroundColor(.red)
                       Text(error)
                           .foregroundColor(.primary)
                           .font(.subheadline)
                           .multilineTextAlignment(.leading)
                   }
               }
           }
           .padding()
           .background(Color.red.opacity(0.05))
           .cornerRadius(8)
           .frame(maxWidth: .infinity, alignment: .center)
       }
   }
}


#Preview {
    ValidationSummaryView(errors: [
        "This is a validation error.",
        "This is a validation error but this one is much longer and should show a wrapping effect.",
        "Another one."
    ])
}
