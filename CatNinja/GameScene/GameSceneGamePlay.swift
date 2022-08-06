//
//  GameSceneGamePlay.swift
//  CatNinja
//
//  Created by Helen Huang on 7/25/22.
//

import SpriteKit

extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        explodeTouchedSprites(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        explodeTouchedSprites(touches: touches)
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
    
    func explodeTouchedSprites(touches: Set<UITouch>) {
        if (self.gameStatus == GameState.isPlaying) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            let touchedNodes = nodes(at: location)
            
            touchedNodes.forEach { node in
                if let spriteNode = node as? SKSpriteNode {
                    if let name = spriteNode.name {
                        updateScore(name: name)
                        updateLives(name: name)
                        updateTime(name: name)
                        playSpriteDestroyedAudio(name: name)
                        explodeSprite(node: spriteNode)
                    }
                }
            }
        }
    }
    
    func explodeSprite(node: SKSpriteNode) {
        if let emitter = SKEmitterNode(fileNamed: "spark") {
            let add = SKAction.run {
                emitter.position = node.position
                emitter.particleColorSequence = nil
                emitter.particleColor = node.color
                self.addChild(emitter)
            }
            
            let wait = SKAction.wait(forDuration: emitter.particleLifetime)
            let remove = SKAction.run { emitter.removeFromParent() }
            let sequence = SKAction.sequence([add, wait, remove])
            self.run(sequence)
        }
        
        // Remove object sprite
        node.removeFromParent()
    }
    
    func playSpriteDestroyedAudio(name: String) {
        if name.contains("Bomb") {
            self.run(SKAction.playSoundFileNamed("glass_break.m4a", waitForCompletion: false))
        } else {
            self.run(SKAction.playSoundFileNamed("sprite_destroyed.m4a", waitForCompletion: false))
        }
    }
    
    func updateTime(name: String) {
        if name.contains("Treat") {
            timerValue += 10
            timerLabel.text = "\(self.timerValue / 60):\(String(format: "%02d", self.timerValue % 60))"
        }
    }
    
    func updateScore(name: String) {
        if name.contains("Yarn") { scoreValue += 100 }
        else if name.contains("Yellow") { scoreValue += 20 }
        else if name.contains("Red") { scoreValue += 10 }
        scoreLabel.text = "\(scoreValue)"
    }
    
    func updateLives(name: String) {
        if name.contains("Bomb") {
            self.lives[self.livesValue].removeFromParent()
            livesValue -= 1
            self.lives[self.livesValue].position = CGPoint(x: frame.maxX - 45.0, y: frame.maxY - 40.0)
            self.addChild(self.lives[self.livesValue])
        }
    }
    
    func checkForEndCondition() {
        if ((self.livesValue <= 0 || self.timerValue < 0) && self.gameStatus != GameState.end) {
            self.gameStatus = GameState.end
            self.removeAction(forKey: "spawnSprites")
            self.removeAction(forKey: "timer")
            showLossScreen()
        }
    }
}
