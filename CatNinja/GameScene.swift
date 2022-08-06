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
    
    
    override func didMove(to view: SKView) {
        self.isUserInteractionEnabled = true
        self.spriteAtlas.preload {}
        deleteAllChildrenAndRespawnUIElements()
        
        // Define buffer frame used for deleting sprites off screen
        self.bufferFrame = CGRect(x: self.view!.frame.origin.x, y: self.view!.frame.origin.y,
                                  width: self.view!.frame.width + 50.0, height: self.view!.frame.height + 50.0)
    }
    
    func restartGame() {
        self.scoreValue = 0
        self.livesValue = 3
        self.timerValue = 60
        self.gameStartCountdownValue = 3
        self.gameStartTime = Date.now
        self.gameStatus = GameState.start
        self.isShowingLossScreen = false
        deleteAllChildrenAndRespawnUIElements()
    }
    
    func deleteAllChildrenAndRespawnUIElements() {
        self.removeAllChildren()
        createBackground()
        createScoreLabel()
        createTimerLabel()
        createLivesLabel()
        positionAndAddGameStartCountdownLabel(label: gameStartCountdownLabel)
    }
    
    func showLossScreen() {
        self.isShowingLossScreen = true
        self.livesValue = max(self.livesValue, 0)
        self.livesLabel.text = "x\(self.livesValue)"
        self.run(SKAction.playSoundFileNamed("game_over.wav", waitForCompletion: false))
        createLossLabel()
        createFinalScoreLabel()
    }
    
    func playCountdownThenSpawnNodesAndBeginTimer() {
        let block = SKAction.run {
            self.gameStartCountdownLabel.text = "\(self.gameStartCountdownValue)"
            self.gameStartCountdownValue -= 1
        }
        let wait = SKAction.wait(forDuration: 0.5)
        let sequence = SKAction.sequence([block, wait])
        self.run(SKAction.repeat(sequence, count: self.gameStartCountdownValue)) {
            self.gameStartCountdownLabel.removeFromParent()
            self.gameStatus = GameState.isPlaying
            self.beginTimer()
            self.spawnSprites()
        }
    }
    
    func beginTimer() {
        let block = SKAction.run {
            if (self.timerValue <= 10) {
                self.timerLabel.fontColor = UIColor(red: 0.8, green: 0.08, blue: 0.07, alpha: 1.0)
            } else {
                self.timerLabel.fontColor = .white
            }
            self.timerLabel.text = "\(self.timerValue / 60):\(String(format: "%02d", self.timerValue % 60))"
            self.timerValue -= 1
        }
        let wait = SKAction.wait(forDuration: 1)
        let sequence = SKAction.sequence([block, wait])
        self.run(SKAction.repeatForever(sequence), withKey: "timer")
    }
    
    func updateTime(name: String) {
        if name.contains("Treat") {
            timerValue += 10
            timerLabel.text = "\(self.timerValue / 60):\(String(format: "%02d", self.timerValue % 60))"
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        deleteSpritesOutOfFrame()
        
        // Update countdown and timer. Starts node spawning
        if (self.gameStatus == GameState.start) {
            self.gameStatus = GameState.countdown
            playCountdownThenSpawnNodesAndBeginTimer()
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
