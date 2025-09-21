//
//  EmojiRatingView.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/5/25.
//

import SwiftUI

struct EmojiRatingView: View {
    let rating: Int
    
    var body: some View {
        switch rating {
        case 0:
            Image(systemName: "questionmark.app")
        case 1,2:
            Text("😠")
        case 3:
            Text("😕")
        default:
            Text("😍")
        }
    }
}

#Preview {
    EmojiRatingView(rating: 3)
}
