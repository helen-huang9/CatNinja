//
//  GameScene.swift
//  CatNinja
//
//  Created by Helen Huang on 1/26/22.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        self.removeAllChildren()
        addYarnToScene(scene: self)
        addSardineToScene(scene: self)
        addBottleToScene(scene: self)
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
