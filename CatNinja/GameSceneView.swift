//
//  GameSceneView.swift
//  CatNinja
//
//  Created by Helen Huang on 1/19/22.
//

import SwiftUI
import SpriteKit

struct GameSceneView: View {
    @Binding public var showingGame: Bool
    @ObservedObject private var scene = GameScene(fileNamed: "GameScene")!
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Button(action: {
                        withAnimation{
                            if (scene.gameStatus == GameState.isPlaying || scene.gameStatus == GameState.countdown) {
                                scene.gameStatus = GameState.pause
                            }
                        }
                    }, label: {
                        ZStack {
                            Image("Paw_Pixel_Art")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 90, height: 90, alignment: .topLeading)
                                .ignoresSafeArea()
                                .padding(.leading, 10.0)
                        }
                    })
                    .offset(x: -20, y: 0)
                    .padding(.top, 40)
                    .buttonStyle(IndentButtonStyle())
                    .transition(.opacity)
                    Spacer()
                }
                Spacer()
            }
            if scene.gameStatus == GameState.isPaused {
                Text("PAUSED")
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2, opacity: 1.0))
                    .font(Font.custom("Copperplate", size: 56))
                    .offset(y: -150)
                
                Button("Resume") { scene.resumeGamePlay() }
                .buttonStyle(PauseScreenButtonStyle())
                .offset(y: -30)
                
                Button("Restart") { scene.restartGame() }
                .buttonStyle(PauseScreenButtonStyle())
                .offset(y: 30)
                
                Button("Quit Game") { showingGame = false }
                .buttonStyle(PauseScreenButtonStyle())
                .offset(y: 90)
            }
            if scene.gameStatus == GameState.end {
                VStack {
                    Button("Play Again") { scene.restartGame() }
                    .buttonStyle(EndGameButtonStyle())
                    .offset(y: 40)
                    
                    Button("Return to Home Screen") { withAnimation{ showingGame = false } }
                    .buttonStyle(EndGameButtonStyle())
                    .offset(y: 50)
                }
            }
        }
        .statusBar(hidden: true)
    }
}
