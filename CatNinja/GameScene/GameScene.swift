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
    case isPaused
    case isPlaying
    case end
}

class GameScene: SKScene, ObservableObject {
    // Game State
    @Published var gameStatus: GameState = GameState.start
    var gameStartTime: Date = Date.now
    
    // Game Screen size
    var bufferFrame: CGRect?
    
    // Combos
    var combo = 0
    
    // Sounds
    let glassBreakSound = SKAction.playSoundFileNamed("glass_break.m4a", waitForCompletion: false)
    let spriteBreakSound = SKAction.playSoundFileNamed("sprite_destroyed.m4a", waitForCompletion: false)
    
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
    let background = SKSpriteNode(imageNamed: "CatNinja_Background2")
    let spriteAtlas = SKTextureAtlas(named: "sprites")
    let spriteNames = ["Yarn_Ball", "Red_Ball", "Yellow_Ball", "Butterfly_Toy", "Feather_Toy", "Mouse_Toy", "Bomb", "Treat"]
    let spriteColors = [UIColor(red: 0.495, green: 0.639, blue: 0.788, alpha: 1.0),
                        UIColor(red: 0.902, green: 0.3294, blue: 0.3294, alpha: 1.0),
                        UIColor(red: 0.9647, green: 0.863, blue: 0.365, alpha: 1.0),
                        UIColor(red: 0.925, green: 0.267, blue: 0.298, alpha: 1.0),
                        UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0),
                        UIColor(red: 0.878, green: 0.816, blue: 0.365, alpha: 1.0),
                        UIColor(red: 0.19, green: 0.39, blue: 0.254, alpha: 1.0),
                        UIColor(red: 0.68, green: 0.56, blue: 0.43, alpha: 1.0)]
    
    
    override func update(_ currentTime: TimeInterval) {
        checkForEndCondition()
    }
}
