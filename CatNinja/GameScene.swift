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
    case isPlaying
    case lose
}

class GameScene: SKScene, ObservableObject {
    @Published var gameStatus: GameState = GameState.start
    var gameStartTime: Date = Date.now
    var isShowingLossScreen = false
    
    var scoreLabel = SKLabelNode()
    var scoreValue = 0
    var livesLabel = SKLabelNode()
    var livesValue = 3
    var gameStartCountdownLabel = SKLabelNode()
    let gameStartCountdownDuration = 2
    
    var bufferFrame: CGRect?
    var lastTimeObjSpawned: Int?
        
    let spriteAtlas = SKTextureAtlas(named: "sprites")
    let spriteNames = ["Yarn_Pixel_Art", "Red_Ball_Pixel_Art", "Yellow_Ball_Pixel_Art"]
    let spriteColors = [UIColor(red: 0.495, green: 0.639, blue: 0.788, alpha: 1.0),
                        UIColor(red: 0.902, green: 0.3294, blue: 0.3294, alpha: 1.0),
                        UIColor(red: 0.9647, green: 0.863, blue: 0.365, alpha: 1.0)]
    
    
    override func didMove(to view: SKView) {
        self.spriteAtlas.preload {}
        deleteAllChildrenAndRespawnUIElements()
        
        // Define buffer frame used for deleting sprites off screen
        self.bufferFrame = CGRect(x: self.view!.frame.origin.x, y: self.view!.frame.origin.y,
                                  width: self.view!.frame.width + 50.0, height: self.view!.frame.height + 50.0);
    }
    
    override var isUserInteractionEnabled: Bool {
        get { return true } set { }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        explodeTouchedSprites(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        explodeTouchedSprites(touches: touches)
    }
    
    func explodeTouchedSprites(touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        touchedNodes.forEach { node in
            if let spriteNode = node as? SKSpriteNode {
                if let name = spriteNode.name {
                    updateScore(name: name)
                    updateLives(name: name)
                    explodeSprite(node: spriteNode)
                }
            }
        }
    }
    
    func explodeSprite(node: SKSpriteNode) {
        if let emitter = SKEmitterNode(fileNamed: "spark") {
            emitter.position = node.position
            emitter.particleColorSequence = nil
            emitter.particleColor = node.color
            self.addChild(emitter)
        }
        node.removeFromParent()
    }
    
    func deleteAllChildrenAndRespawnUIElements() {
        self.removeAllChildren()
        createBackground()
        createScoreLabel()
        createLivesLabel()
        positionAndAddGameStartCountdownLabel(label: gameStartCountdownLabel)
    }
    
    func deleteObjectsOutOfFrame() {
        self.children.forEach { node in
            let pos = self.convertPoint(toView: node.position);
            if (!self.bufferFrame!.contains(pos)) {
                if let name = node.name {
                    if !name.contains("Red") { updateScore(name: "OutOfBounds") }
                }
                node.removeFromParent()
            }
        }
    }
    
    func updateScore(name: String) {
        if name.contains("Yarn") { scoreValue += 100 }
        else if name.contains("Yellow") { scoreValue += 20 }
        else if name.contains("Red") { scoreValue -= 50 }
        else if name.contains("OutOfBounds") { scoreValue -= 30}
        scoreLabel.text = "\(scoreValue)"
    }
    
    func updateLives(name: String) {
        if name.contains("Red") { livesValue -= 1 }
        livesLabel.text = "x\(livesValue)"
    }
    
    func showLossScreen() {
        self.isShowingLossScreen = true
        self.livesValue = 0
        self.livesLabel.text = "x\(self.livesValue)"
        createLossLabel()
        createFinalScoreLabel()
    }
    
    func updateGameStatus() {
        if (self.gameStatus == GameState.start && Int(self.gameStartTime.timeIntervalSinceNow) < -self.gameStartCountdownDuration) {
            self.gameStatus = GameState.isPlaying
            self.gameStartCountdownLabel.removeFromParent()
        }
        else if (livesValue < 0 && self.gameStatus != GameState.lose) {
            self.gameStatus = GameState.lose
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateGameStatus()
        
        if (self.gameStatus == GameState.isPlaying) {
            let intTime = Int(currentTime)
            deleteObjectsOutOfFrame()
            if (intTime % 1 == 0 && (lastTimeObjSpawned == nil || lastTimeObjSpawned! < intTime)) {
                lastTimeObjSpawned = intTime
                for _ in 0...Int.random(in: 0...1) {
                    addSpriteToSceneWithRandomization(num: Int.random(in: 0..<self.spriteNames.count))
                }
            }
        }
        else if (self.gameStatus == GameState.lose && !self.isShowingLossScreen) {
            showLossScreen()
        }
        else if (self.gameStatus == GameState.start) {
            self.gameStartCountdownLabel.text = "\(self.gameStartCountdownDuration + Int(self.gameStartTime.timeIntervalSinceNow) + 1)"
        }
    }
}
