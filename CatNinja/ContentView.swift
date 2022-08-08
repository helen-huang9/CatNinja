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
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let height = geometry.size.height
                let width = geometry.size.width
                
                let iPadButtonWidth = (2*width)/5
                let buttonScale = max(iPadButtonWidth/1000, 0.22) /// uses the iPadButtonWidth if screen is sufficently large
                
                // Home Screen
                if !showingGame {
                    // Background view
                    BackgroundView(w: width, h: height)
                    
                    // New Game button
                    Button(action: {
                        withAnimation{
                            showingGame = true
                            showingSpriteInfo = false
                        }
                    }) {
                        Image("New_Game_Button")
                            .scaleEffect(buttonScale)
                    }
                    .buttonStyle(IndentButtonStyle())
                    .position(x: width/2, y: height/2 - 50)
                    
                    // Sprite Info button
                    Button(action: {
                        withAnimation{showingSpriteInfo = true}
                    }) {
                        Image("Sprite_Info_Button")
                            .scaleEffect(buttonScale)
                    }
                    .buttonStyle(IndentButtonStyle())
                    .position(x: width/2, y: height/2 + 60)
                    
                    // Sprite Info View
                    if showingSpriteInfo {
                        ZStack {
                            SpriteInfoView(w: width, h: height)
                            Button("X") { showingSpriteInfo = false }
                                .font(Font.custom("Chalkduster", size: 40))
                                .foregroundColor(.black)
                                .position(x: width/2 + 150, y: height/2 - 185)
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
        }
        .statusBar(hidden: true)
        .ignoresSafeArea()
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
            let desiredH = (2*height)/3 - 50
            let scale = desiredH / 1000
            
            Image("Home_Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .position(x: width/2, y: height/2)
            Image("Left_Katana")
                .scaleEffect(scale)
                .position(x: width/2, y: height/2 + 5)
                .rotationEffect(Angle(degrees: 35))
            Image("Right_Katana")
                .scaleEffect(scale)
                .position(x: width/2, y: height/2)
                .rotationEffect(Angle(degrees: -35))
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
                    .scaleEffect(0.9)
                
                Text("Sprite Info")
                    .font(Font.custom("Chalkduster", size: 28))
                    .foregroundColor(.black)
                    .position(x: width/2 - 65, y: height/2 - 190)
                
                Text("= +10")
                    .font(Font.custom("Chalkduster", size: 24))
                    .foregroundColor(.black)
                    .position(x: width/2 - 20, y: height/2 - 145)
                Text("= +20")
                    .font(Font.custom("Chalkduster", size: 24))
                    .foregroundColor(.black)
                    .position(x: width/2 - 20, y: height/2 - 72)
                Text("= +100")
                    .font(Font.custom("Chalkduster", size: 24))
                    .foregroundColor(.black)
                    .position(x: width/2 - 12, y: height/2 - 2)
                Text("= -1 life")
                    .font(Font.custom("Chalkduster", size: 24))
                    .foregroundColor(.black)
                    .position(x: width/2, y: height/2 + 70)
                Text("= +10 seconds")
                    .font(Font.custom("Chalkduster", size: 24))
                    .foregroundColor(.black)
                    .position(x: width/2 + 38, y: height/2 + 140)
                
                Text("* Combos can be achieved by destroying sprites \n without lifting the finger. Lifting the finger or \n destroying a bomb restarts the combo.")
                    .lineLimit(nil)
                    .font(Font.custom("Chalkduster", size: 10))
                    .foregroundColor(.black)
                    .position(x: width/2, y: height/2 + 190)
            }
        }
    }
}
