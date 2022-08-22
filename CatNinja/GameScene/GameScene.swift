//
//  GameScene.swift
//  CatNinja
//
//  Created by Helen Huang on 1/26/22.
//

import SpriteKit
import SwiftUI

/// The game states of the GameScene.
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
    var gameStartTime = Date.now
    
    // Game Screen size
    var bufferFrame: CGRect?
    
    // iPhone vs iPad values
    let velocityMultiplier = UIDevice.current.userInterfaceIdiom == .phone ? 1.1 : 0.8
    
    // Labels, Score, Lives, Timer, Combo
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
    var combo = 0
        
    // Sounds
    let waterSplashSound = SKAction.playSoundFileNamed("splash.m4a", waitForCompletion: false)
    let spriteBreakSound = SKAction.playSoundFileNamed("sprite_destroyed.m4a", waitForCompletion: false)
    let meow1Sound = SKAction.playSoundFileNamed("meow1.m4a", waitForCompletion: false)
    let meow2Sound = SKAction.playSoundFileNamed("meow2.m4a", waitForCompletion: false)
    let angry1Sound = SKAction.playSoundFileNamed("angry1.m4a", waitForCompletion: false)
    let angry2Sound = SKAction.playSoundFileNamed("angry2.m4a", waitForCompletion: false)
    let toy1Sound = SKAction.playSoundFileNamed("toy1.m4a", waitForCompletion: false)
    let toy2Sound = SKAction.playSoundFileNamed("toy2.m4a", waitForCompletion: false)
    let collectSound = SKAction.playSoundFileNamed("collect.m4a", waitForCompletion: false)
    
    // Textures
    let background = SKSpriteNode(imageNamed: "CatNinja_Background2")
    let spriteAtlas = SKTextureAtlas(named: "sprites")
    let sprites = [
        Sprite(imgName: "Blue_Yarn_Ball", color: UIColor(red: 0.495, green: 0.639, blue: 0.788, alpha: 1.0), scale: 3),
        Sprite(imgName: "Pink_Yarn_Ball", color: UIColor(red: 0.969, green: 0.616, blue: 0.867, alpha: 1.0), scale: 3),
        Sprite(imgName: "Orange_Yarn_Ball", color: UIColor(red: 0.984, green: 0.494, blue: 0.267, alpha: 1.0), scale: 3),
        Sprite(imgName: "Butterfly_Toy", color: UIColor(red: 0.925, green: 0.267, blue: 0.298, alpha: 1.0), scale: 3.5),
        Sprite(imgName: "Feather_Toy", color: UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0), scale: 3),
        Sprite(imgName: "Mouse_Toy", color: UIColor(red: 0.878, green: 0.816, blue: 0.365, alpha: 1.0), scale: 3),
        Sprite(imgName: "Bomb", color: UIColor(red: 0.765, green: 0.869, blue: 0.933, alpha: 1.0), scale: 3),
        Sprite(imgName: "Treat", color: UIColor(red: 0.68, green: 0.56, blue: 0.43, alpha: 1.0), scale: 2)
    ]
}
