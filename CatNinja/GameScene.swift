//
//  GameScene.swift
//  CatNinja
//
//  Created by Helen Huang on 1/26/22.
//

import SpriteKit

class GameScene: SKScene {
    
    override var isUserInteractionEnabled: Bool {
        get {
            return true
        } set {
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        
        self.children.forEach { node in
            node.position = location
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.children.forEach { node in
            guard let view = self.view else {
                return
            }
            let minX = view.bounds.minX
            let minY = view.bounds.minY
            let maxX = view.bounds.maxX
            let maxY = view.bounds.maxY
            
            let x = CGFloat.random(in: minX ... maxX) - view.bounds.midX
            let y = CGFloat.random(in: minY ... maxY) - view.bounds.midY
            
            node.position = CGPoint(x: x, y: y)
        }
    }
}
