//
//  GameScene.swift
//  CatNinja
//
//  Created by Helen Huang on 1/26/22.
//

import SpriteKit

class GameScene: SKScene {
    var gameStatus = "isPlaying"
    var scoreLabel = SKLabelNode(text: "0")
    var scoreValue = 0
    var livesLabel = SKLabelNode(text: "x3")
    var livesValue = 3
    
    var bufferFrame: CGRect?
    let spriteAtlas = SKTextureAtlas(named: "sprites")
    let spriteNames = ["Yarn_Pixel_Art", "Red_Ball_Pixel_Art", "Yellow_Ball_Pixel_Art"]
    
    var lastTimeObjSpawned: Int?
    
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
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        touchedNodes.forEach { node in
            if let spriteNode = node as? SKSpriteNode {
                if let name = spriteNode.name {
                    updateScore(name: name)
                    updateLives(name: name)
                    if let emitter = SKEmitterNode(fileNamed: "spark") {
                        emitter.position = spriteNode.position
                        self.addChild(emitter)
                    }
                    spriteNode.removeFromParent()
                }
            }
        }
    }
    
    func deleteAllChildrenAndRespawnUIElements() {
        self.removeAllChildren()
        createBackground()
        createScoreLabel()
        createLivesLabel()
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
    
    func updateGameStatus() {
        if (livesValue < 0 && self.gameStatus != "loss") {
            self.gameStatus = "loss"
            showLossScreen()
        }
    }
    
    func showLossScreen() {
        createLossLabel()
        createFinalScoreLabel()
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateGameStatus()
        
        if (self.gameStatus == "isPlaying") {
            deleteObjectsOutOfFrame()
            let intTime = Int(currentTime)
            if (intTime % 1 == 0 && (lastTimeObjSpawned == nil || lastTimeObjSpawned! < intTime)) {
                lastTimeObjSpawned = intTime
                addSpriteToSceneWithRandomization(num: Int.random(in: 0..<self.spriteNames.count))
            }
        }
    }
}
