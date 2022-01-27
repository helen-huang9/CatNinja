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
        print(self.children)
    }
}
