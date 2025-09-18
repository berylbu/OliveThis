//
//  ProductDetailScreen.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/4/25.
//

import SwiftUI

struct ProductDetailScreen: View {
    
    let product: Product
    
    var body: some View {
        ScrollView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(product.images, id: \.self) { imageURL in
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipped()
                                .cornerRadius(12)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 200, height: 200)
                                .overlay(ProgressView())
                        }
                    }
                }.padding(.horizontal)
            }
            
            VStack(alignment: .leading) {
                // Title
                Text(product.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                // Price
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.title2)
                    .foregroundColor(.green)
                
                // Description
                Text(product.description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }.padding()
        }.navigationTitle(product.title)
       
    }
}

#Preview {
    NavigationStack {
        ProductDetailScreen(product: Product.preview)
    }
}
