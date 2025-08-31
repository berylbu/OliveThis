//
//  ImagePlaceholderView.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/31/25.
//

import SwiftUI

struct ImagePlaceholderView: View {
    
    var width: CGFloat = 75
    var height: CGFloat = 75
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.secondary.opacity(0.15))
                .frame(width: width, height: height)
                .overlay(
                    RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                        .stroke(Color.secondary.opacity(0.4), lineWidth: 1)
                        .font(.system(size:24))
                    )
            Image(systemName: "photo")
                .foregroundColor(.secondary.opacity(0.4))
                .font(.system(size:24))
        }
    }
}

#Preview {
    ImagePlaceholderView()
}
