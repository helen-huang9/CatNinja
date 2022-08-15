//
//  ButtonStyles.swift
//  CatNinja
//
//  Created by Helen Huang on 8/5/22.
//

import SwiftUI

/// Button Style for the Buttons on the GameScene end screen.
struct EndGameButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2, opacity: 1.0))
            .padding([.top, .bottom], 5)
            .padding([.leading, .trailing], 10)
            .font(Font.custom("Copperplate", size: 16))
            .background(Color(red: 0.85, green: 0.85, blue: 0.9, opacity: 0.85).cornerRadius(20))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .transition(.opacity)
    }
}

/// Button Style for the Buttons on the GameSceneView pause screen.
struct PauseScreenButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2, opacity: 1.0))
            .padding([.top, .bottom], 5)
            .padding([.leading, .trailing], 10)
            .font(Font.custom("Copperplate", size: 32))
            .background(Color(red: 0.85, green: 0.85, blue: 0.9, opacity: 0.85).cornerRadius(20))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

/// Button Style for the Buttons on the ContentView home screen.
struct IndentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

