//
//  GameScene.swift
//  CatNinja
//
//  Created by Helen Huang on 1/26/22.
//

import SpriteKit

class GameScene: SKScene {
    
    var lastTimeObjSpawned:Int?
    
    override func didMove(to view: SKView) {
        self.removeAllChildren()
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
        // Spawn objects into scene
        let intTime = Int(currentTime)
        if (intTime % 2 == 0 && (lastTimeObjSpawned == nil || lastTimeObjSpawned! < intTime)) {
            let obj = Int.random(in: 0...2)
            lastTimeObjSpawned = intTime
            print("System time:", intTime)
            print("New Object Spawned:", obj)
            switch obj {
            case 0:
                addYarnToSceneWithRandomization(scene: self)
            case 1:
                addBottleToSceneWithRandomization(scene: self)
            case 2:
                addSardineToSceneWithRandomization(scene: self)
            default:
                addYarnToSceneWithRandomization(scene: self)
            }
        }
        
        // Delete objects when they go out of our buffer frame
        let bufferFrame = getBuffer(buffer: 20.0);
        deleteObjects(bufferFrame: bufferFrame);
    }
}
