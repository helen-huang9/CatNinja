//
//  ContentView.swift
//  CatNinja
//
//  Created by Helen Huang on 1/19/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingGame = false
    @State private var showingSpriteInfo = false
    let height: CGFloat = 850
    let width: CGFloat = 650
    
    var body: some View {
        ZStack {
            // Home Screen
            if !showingGame {
                // Background Image
                BackgroundView(w: width, h: height)
                
                // New Game button
                Button(action: {
                    withAnimation{
                        showingGame = true
                        showingSpriteInfo = false
                    }
                }) {
                    Image("New_Game_Button")
                        .scaleEffect(x: 0.2, y: 0.2, anchor: .center)
                }
                .buttonStyle(IndentButtonStyle())
                .position(x: width/2, y: height/2 - 100)
                
                // Settings button
                Button(action: {}) {
                    Image("Settings_Button")
                        .scaleEffect(x: 0.2, y: 0.2, anchor: .center)
                }
                .buttonStyle(IndentButtonStyle())
                .position(x: width/2, y: height/2)
                
                // Sprite Info button
                Button(action: {
                    withAnimation{showingSpriteInfo = true}
                }) {
                    Image("Sprite_Info_Button")
                        .scaleEffect(x: 0.22, y: 0.22, anchor: .center)
                }
                .buttonStyle(IndentButtonStyle())
                .position(x: width/2, y: height/2 + 100)
                
                // Sprite Info View
                if showingSpriteInfo {
                    ZStack {
                        SpriteInfoView(w: width, h: height)
                        Button("X") { showingSpriteInfo = false }
                            .font(Font.custom("Chalkduster", size: 40))
                            .foregroundColor(.black)
                            .position(x: width - 180, y: height/4 + 30)
                    }
                }
            }
            // Game Scene Screen
            else if !showingSpriteInfo && showingGame {
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

struct BackgroundView: View {
    var width: CGFloat
    var height: CGFloat
    init (w: CGFloat, h: CGFloat) {
        width = w
        height = h
    }
    
    var body: some View {
        ZStack {
            Image("Home_Background")
                .resizable()
                .frame(width: width, height: height, alignment: .center)
                .ignoresSafeArea()
            
            Image("Left_Katana")
                .scaleEffect(x: 0.4, y: 0.4, anchor: .center)
                .position(x: width/2 - 150, y: height/2 + 3)
            Image("Right_Katana")
                .scaleEffect(x: 0.4, y: 0.4, anchor: .center)
                .position(x: width/2 + 150, y: height/2)
        }
    }
}

struct SpriteInfoView: View {
    var width: CGFloat
    var height: CGFloat
    init (w: CGFloat, h: CGFloat) {
        width = w
        height = h
    }
    
    var body: some View {
        ZStack {
            ZStack {
                Image("Sprite_Info")
                    .scaleEffect(x: 0.9, y: 0.9, anchor: .center)
                
                Text("Sprite Info")
                    .font(Font.custom("Chalkduster", size: 28))
                    .foregroundColor(.black)
                    .position(x: width/3 + 50, y: height/4 + 30)
                
                Text("= +10")
                    .font(Font.custom("Chalkduster", size: 24))
                    .foregroundColor(.black)
                    .position(x: width/2 - 20, y: height/3 - 5)
                Text("= +20")
                    .font(Font.custom("Chalkduster", size: 24))
                    .foregroundColor(.black)
                    .position(x: width/2 - 20, y: height/3 + 70)
                Text("= +100")
                    .font(Font.custom("Chalkduster", size: 24))
                    .foregroundColor(.black)
                    .position(x: width/2 - 12, y: height/3 + 140)
                Text("= -1 life")
                    .font(Font.custom("Chalkduster", size: 24))
                    .foregroundColor(.black)
                    .position(x: width/2, y: height/3 + 210)
                Text("= +10 seconds")
                    .font(Font.custom("Chalkduster", size: 24))
                    .foregroundColor(.black)
                    .position(x: width/2 + 35, y: height/3 + 280)
                
                Text("* Combos can be achieved by destroying sprites \n without lifting the finger. Lifting the finger or \n destroying a bomb restarts the combo.")
                    .lineLimit(nil)
                    .font(Font.custom("Chalkduster", size: 10))
                    .foregroundColor(.black)
                    .position(x: width/2, y: height/3 + 330)
            }
        }
    }
}
