//
//  GameSceneGamePlay.swift
//  CatNinja
//
//  Created by Helen Huang on 7/25/22.
//

import SpriteKit

extension GameScene {
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
                    updateTime(name: name)
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
}
