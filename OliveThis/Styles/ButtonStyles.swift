//
//  ButtonStyles.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/11/25.
//

import SwiftUI

struct OlivePrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    var shadowColor: Color = .black
    var shadowRadius: CGFloat = 4
    var shadowX: CGFloat = 0
    var shadowY: CGFloat = 5
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isEnabled ? Color.blue : Color.gray)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(
                color: configuration.isPressed ? shadowColor.opacity(0.3) : shadowColor.opacity(0.1),
                radius: configuration.isPressed ? shadowRadius / 2 : shadowRadius,
                x: shadowX,
                y: shadowY
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == OlivePrimaryButtonStyle {
    static var olivePrimaryButton: OlivePrimaryButtonStyle {
        OlivePrimaryButtonStyle()
    }
}

struct OliveSecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    var shadowColor: Color = .black
    var shadowRadius: CGFloat = 4
    var shadowX: CGFloat = 0
    var shadowY: CGFloat = 5
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isEnabled ? Color.green : Color.gray)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(
                color: configuration.isPressed ? shadowColor.opacity(0.3) : shadowColor.opacity(0.1),
                radius: configuration.isPressed ? shadowRadius / 2 : shadowRadius,
                x: shadowX,
                y: shadowY
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == OliveSecondaryButtonStyle {
    static var oliveSecondaryButton: OliveSecondaryButtonStyle {
        OliveSecondaryButtonStyle()
    }
}

struct ButtonStyles: View {
    var body: some View {
        VStack {
            Button("Primary Button Style") {
            }.buttonStyle(.olivePrimaryButton)
            
            Button("Primary Button Disable Style") {
            }.buttonStyle(.olivePrimaryButton)
                .disabled(true)
            
            Button("Secondary Button Style") {
            }.buttonStyle(.oliveSecondaryButton)
        }
    }
}

#Preview {
    ButtonStyles()
}
