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
            emitter.position = node.position
            emitter.particleColorSequence = nil
            emitter.particleColor = node.color
            self.addChild(emitter)
        }
        node.removeFromParent()
    }
    
    func playSpriteDestroyedAudio(name: String) {
        if name.contains("Bomb") {
            self.run(SKAction.playSoundFileNamed("glass_break.m4a", waitForCompletion: false))
        } else {
            self.run(SKAction.playSoundFileNamed("sprite_destroyed.m4a", waitForCompletion: false))
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
            livesValue -= 1
            livesLabel.text = "x\(livesValue)"
        }
    }
}
