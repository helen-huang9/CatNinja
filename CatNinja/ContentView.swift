//
//  ContentView.swift
//  CatNinja
//
//  Created by Helen Huang on 1/19/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingGame = false
    
    var body: some View {
        ZStack {
            // Home Screen
            if !showingGame {
                // Background Image
                Image("Home_Background")
                    .resizable()
                    .frame(width: 650, height: 850, alignment: .center)
                    .ignoresSafeArea()
                
                // Play game button
                Button(action: {
                    withAnimation{showingGame = true}
                }) {
                    ZStack {
                        Image("orange_cat_button")
                            .scaleEffect(x: 0.25, y: 0.25, anchor: .center)
                            .padding(.bottom, 20.0)
                            .foregroundColor(Color.black)
                        Text("Play")
                            .foregroundColor(Color.black)
                            .font(Font.custom("Copperplate-Bold", size: 36))
                            .frame(width: 200.0, height: 50.0)
                    }
                }
                .buttonStyle(IndentButtonStyle())
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
