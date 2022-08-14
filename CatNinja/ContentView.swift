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
                    .position(x: width/2, y: (3*height)/7)
                    
                    // Sprite Info button
                    Button(action: {
                        withAnimation{showingSpriteInfo = true}
                    }) {
                        Image("Game_Info_Button")
                            .scaleEffect(buttonScale)
                    }
                    .buttonStyle(IndentButtonStyle())
                    .position(x: width/2, y: (4*height)/7)
                    
                    // Sprite Info View
                    if showingSpriteInfo {
                        let infoScale = ((5*height)/9)/450
                        ZStack {
                            SpriteInfoView(w: width, h: height)
                            Button("X") { showingSpriteInfo = false }
                                .font(Font.custom("Chalkduster", size: 40))
                                .foregroundColor(.black)
                                .position(x: width/2 + 135, y: height/2 - 205)
                        }
                        .scaleEffect(infoScale)
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
                Image("Sprite_Info-1")
                    .scaleEffect(0.9)
                    .position(x: width/2, y: height/2)
                
                Text("Sprite Info")
                    .font(Font.custom("Chalkduster", size: 28))
                    .foregroundColor(.black)
                    .position(x: width/2 - 60, y: height/2 - 210)
                
                Text("= +50")
                    .font(Font.custom("Chalkduster", size: 24))
                    .foregroundColor(.black)
                    .position(x: width/2, y: height/2 - 155)
                Text("= +100")
                    .font(Font.custom("Chalkduster", size: 24))
                    .foregroundColor(.black)
                    .position(x: width/2 + 10, y: height/2 - 60)
                Text("= -1 life")
                    .font(Font.custom("Chalkduster", size: 24))
                    .foregroundColor(.black)
                    .position(x: width/2 + 10, y: height/2 + 25)
                Text("= +10 seconds")
                    .font(Font.custom("Chalkduster", size: 24))
                    .foregroundColor(.black)
                    .position(x: width/2 + 45, y: height/2 + 95)
                
                Text("* Combos can be achieved by destroying \n sprites without lifting the finger. Lifting \n the finger or destroying a bomb restarts \n the combo.")
                    .lineLimit(nil)
                    .font(Font.custom("Chalkduster", size: 12))
                    .foregroundColor(.black)
                    .position(x: width/2, y: height/2 + 180)
            }
        }
    }
}
