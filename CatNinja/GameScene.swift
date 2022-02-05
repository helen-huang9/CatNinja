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
//        secondHalf.setScale(0.2)
        secondHalf.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "yarn-half-1"), size: secondHalf.size)
        secondHalf.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        self.addChild(firstHalf)
        firstHalf.addChild(secondHalf)
        
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
        
        let touchedNodes = nodes(at: location)
        
        touchedNodes.forEach { node in
            if let spriteNode = node as? SKSpriteNode {
                let root = getRootNode(node: spriteNode)
                explode(node: root)
            }
        }
    }
    
    func explode(node: SKSpriteNode) {
        node.physicsBody?.joints.forEach { joint in
            self.physicsWorld.remove(joint)
        }
        node.physicsBody?.velocity = CGVector(dx: CGFloat.random(in: -100 ... 100), dy: CGFloat.random(in: -100 ... 100))
        
        node.children.forEach { child in
            if let spriteChild = child as? SKSpriteNode {
                spriteChild.setScale(0.2)
                spriteChild.move(toParent: self)
                explode(node: spriteChild)
            }
        }
    }
    
    func getRootNode(node: SKSpriteNode) -> SKSpriteNode {
        guard let parent = node.parent as? SKSpriteNode else {
            return node
        }
        return getRootNode(node: parent)
    }
    
    func deleteObjects(bufferFrame: CGRect) {
        self.children.forEach { node in
            let pos = self.convertPoint(toView: node.position);
            if (!bufferFrame.contains(pos)) {
                node.removeFromParent();
            }
        }
    }
    
    func getBuffer(buffer: CGFloat) -> CGRect {
        let view = self.view!
        return CGRect(x: view.frame.origin.x, y: view.frame.origin.y,
                      width: view.frame.width + buffer, height: view.frame.height + buffer);
    }
    
    override func update(_ currentTime: TimeInterval) {
        let bufferFrame = getBuffer(buffer: 20.0);
        deleteObjects(bufferFrame: bufferFrame);
    }
}
