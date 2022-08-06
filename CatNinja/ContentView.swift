//
//  ContentView.swift
//  CatNinja
//
//  Created by Helen Huang on 1/19/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingGame = false
    let height: CGFloat = 850
    let width: CGFloat = 650
    
    var body: some View {
        ZStack {
            // Home Screen
            if !showingGame {
                // Background Image
                Image("Home_Background")
                    .resizable()
                    .frame(width: width, height: height, alignment: .center)
                    .ignoresSafeArea()
                
                // New Game button
                Button(action: {
                    withAnimation{showingGame = true}
                }) {
                    Image("New_Game_Button")
                        .scaleEffect(x: 0.25, y: 0.25, anchor: .center)
                }
                .buttonStyle(IndentButtonStyle())
                .position(x: width/2, y: height/2)
                
                // Claws button
                Button(action: {}) {
                    Image("Claws_Button")
                        .scaleEffect(x: 0.15, y: 0.15, anchor: .center)
                }
                .buttonStyle(IndentButtonStyle())
                .position(x: width/2 - 85, y: height/2 + 100)
                
                // Settings button
                Button(action: {}) {
                    Image("Settings_Button")
                        .scaleEffect(x: 0.15, y: 0.15, anchor: .center)
                }
                .buttonStyle(IndentButtonStyle())
                .position(x: width/2 + 85, y: height/2 + 100)
            }
            // Game Scene
            else {
                GameSceneView(showingGame: $showingGame)
                .ignoresSafeArea(edges: .all)
                .transition(.opacity)
            }
        }
        .statusBar(hidden: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
