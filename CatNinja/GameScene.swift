//
//  GameScene.swift
//  CatNinja
//
//  Created by Helen Huang on 1/26/22.
//

import SpriteKit

class GameScene: SKScene {
    
    override func sceneDidLoad() {
        let firstHalf = SKSpriteNode(imageNamed: "yarn-half-2")
        firstHalf.name = "first half"
        firstHalf.setScale(0.2)
        firstHalf.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "yarn-half-2"), size: firstHalf.size)
        firstHalf.physicsBody?.velocity = CGVector(dx: 50, dy: -50)
        firstHalf.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        let secondHalf = SKSpriteNode(imageNamed: "yarn-half-1")
        secondHalf.name = "second half"
        secondHalf.setScale(0.2)
        secondHalf.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "yarn-half-1"), size: secondHalf.size)
        secondHalf.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        self.addChild(firstHalf)
        self.addChild(secondHalf)
        
        let mid = CGPoint(x: 0, y: 0)
        let firstHalfJoint = SKPhysicsJointFixed.joint(withBodyA: firstHalf.physicsBody!, bodyB: secondHalf.physicsBody!, anchor: mid)
        
        self.physicsWorld.add(firstHalfJoint)
    }
    
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
//        self.children.forEach { node in
//            guard let view = self.view else {
//                return
//            }
//            let minX = view.bounds.minX
//            let minY = view.bounds.minY
//            let maxX = view.bounds.maxX
//            let maxY = view.bounds.maxY
//
//            let x = CGFloat.random(in: minX ... maxX) - view.bounds.midX
//            let y = CGFloat.random(in: minY ... maxY) - view.bounds.midY
//
//            node.position = CGPoint(x: x, y: y)
//        }
    }
}
