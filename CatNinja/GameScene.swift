//
//  GameScene.swift
//  CatNinja
//
//  Created by Helen Huang on 1/26/22.
//

import SpriteKit

class GameScene: SKScene {
    
    var lastTimeObjSpawned: Int?
    var scoreLabel = SKLabelNode(text: "Score: 0")
    var scoreValue = 0
    
    override func didMove(to view: SKView) {
        self.removeAllChildren()
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: frame.maxX - 30, y: frame.maxY - 40)
        self.addChild(scoreLabel)
    }
    
    override var isUserInteractionEnabled: Bool {
        get {
            return true
        } set {
            
        }
    }
    
    /// Touch-screen actionable events
    /// - Parameters:
    ///   - touches: Set of touches by the user
    ///   - event: (type of touch?)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        
        let touchedNodes = nodes(at: location)
        
        touchedNodes.forEach { node in
            if let spriteNode = node as? SKSpriteNode {
                if let name = node.name {
                    updateScore(name: name)
                }
                let root = getRootNode(node: spriteNode)
                explode(node: root)
            }
        }
    }
    
    /// Recursively "explode" all fragments of a node; makes each fragment a node child to the scene
    /// - Parameter node: NodeSprite, represented as a yarn, sardine, etc.
    func explode(node: SKSpriteNode) {
        node.physicsBody!.joints.forEach { joint in
            self.physicsWorld.remove(joint)
        }
        node.physicsBody!.velocity = CGVector(dx: CGFloat.random(in: -100 ... 100), dy: CGFloat.random(in: -100 ... 100))
        node.physicsBody!.collisionBitMask = 0
        
        
        node.children.forEach { child in
            if let spriteChild = child as? SKSpriteNode {
                spriteChild.setScale(0.2)
                spriteChild.move(toParent: self)
                explode(node: spriteChild)
            }
        }
    }
    
    /// Get the root/parent fragment of a node object
    /// - Parameter node: NodeSprite, represented as a yarn, sardine, etc.
    /// - Returns: The parent fragment node of the inputted node
    func getRootNode(node: SKSpriteNode) -> SKSpriteNode {
        guard let parent = node.parent as? SKSpriteNode else {
            return node
        }
        return getRootNode(node: parent)
    }
    
    
    /// Delete the nodes that move outside of the buffer frame
    /// - Parameter bufferFrame: CGRect frame that outlines the buffer frame
    func deleteObjects(bufferFrame: CGRect) {
        self.children.forEach { node in
            let pos = self.convertPoint(toView: node.position);
            if (!bufferFrame.contains(pos)) {
                node.removeFromParent()
            }
        }
    }
    
    func updateScore(name: String) {
        if name.contains("yarn") {
            scoreValue += 10
        }
        else if name.contains("sardine") {
            scoreValue += 20
        }
        else {
            scoreValue -= 30
        }
        scoreLabel.text = "Score: \(scoreValue)"
    }
    
    // Gets the frame buffer used for spawning nodes within the frame but out of sight and deleting nodes outside of buffer frame
    func getFrameBuffer(buffer: CGFloat) -> CGRect {
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
        let bufferFrame = getFrameBuffer(buffer: 20.0);
        deleteObjects(bufferFrame: bufferFrame);
    }
}
