//
//  GameScene.swift
//  CatNinja
//
//  Created by Helen Huang on 1/26/22.
//

import SpriteKit
import SwiftUI

enum GameState {
    case start
    case countdown
    case pause
    case isPaused
    case isPlaying
    case end
}

class GameScene: SKScene, ObservableObject {
    // Game State
    @Published var gameStatus: GameState = GameState.start
    var gameStartTime: Date = Date.now
    var isShowingLossScreen = false
    
    // Game Screen size
    var bufferFrame: CGRect?
    
    // Labels
    let font = "Copperplate"
    var scoreLabel = SKLabelNode()
    var scoreValue = 0
    var livesLabel = SKLabelNode()
    var livesValue = 3
    let lives = [SKSpriteNode(imageNamed: "Cat_Life_0"), SKSpriteNode(imageNamed: "Cat_Life_1"),
                 SKSpriteNode(imageNamed: "Cat_Life_2"), SKSpriteNode(imageNamed: "Cat_Life_3")]
    var timerLabel = SKLabelNode()
    var timerValue = 60 // in seconds
    var gameStartCountdownLabel = SKLabelNode()
    var gameStartCountdownValue = 3 // in seconds
        
    // Textures
    let spriteAtlas = SKTextureAtlas(named: "sprites")
    let spriteNames = ["Yarn_Pixel_Art", "Red_Ball_Pixel_Art", "Yellow_Ball_Pixel_Art", "Treat", "Splash_Bomb"]
    let spriteColors = [UIColor(red: 0.495, green: 0.639, blue: 0.788, alpha: 1.0),
                        UIColor(red: 0.902, green: 0.3294, blue: 0.3294, alpha: 1.0),
                        UIColor(red: 0.9647, green: 0.863, blue: 0.365, alpha: 1.0),
                        UIColor(red: 0.68, green: 0.56, blue: 0.43, alpha: 1.0),
                        UIColor(red: 0.19, green: 0.39, blue: 0.254, alpha: 1.0)]
    
    func resumeGamePlay() {
        if let view = self.view {
            view.isPaused = false
            self.gameStatus = GameState.isPlaying
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        deleteSpritesOutOfFrame()
        
        // Update countdown and timer. Starts node spawning
        if (self.gameStatus == GameState.start) {
            self.gameStatus = GameState.countdown
            playCountdownThenSpawnNodesAndBeginTimer()
        }
        // Pause screen
        else if (self.gameStatus == GameState.pause) {
            self.gameStatus = GameState.isPaused
            if let view = self.view { view.isPaused = true }
        }
        // Check for end condition
        else if ((self.livesValue <= 0 || self.timerValue < 0) && self.gameStatus != GameState.end) {
            self.gameStatus = GameState.end
            self.removeAction(forKey: "spawnSprites")
            self.removeAction(forKey: "timer")
            showLossScreen()
        }
    }
}
