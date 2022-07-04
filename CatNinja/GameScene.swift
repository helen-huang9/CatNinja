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
    var bufferFrame: CGRect?
    let spriteAtlas = SKTextureAtlas(named: "sprites")
    
    override func didMove(to view: SKView) {
        self.removeAllChildren()
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: frame.maxX - 30, y: frame.maxY - 40)
        self.addChild(scoreLabel)
        
        self.bufferFrame = CGRect(x: self.view!.frame.origin.x, y: self.view!.frame.origin.y,
                                  width: self.view!.frame.width + 30.0, height: self.view!.frame.height + 30.0);
        self.spriteAtlas.preload {}
        self.physicsWorld.speed = 0.9999
    }
    
    override var isUserInteractionEnabled: Bool {
        get { return true } set { }
    }
    
    /// Touch-screen actionable events
    /// - Parameters:
    ///   - touches: Set of touches by the user
    ///   - event: (type of touch?)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        touchedNodes.forEach { node in
            if let spriteNode = node as? SKSpriteNode {
                if let name = spriteNode.name {
                    updateScore(name: name)
                    spriteNode.removeFromParent()
                }
            }
        }
    }
    
    /// Delete the nodes that move outside of the buffer frame
    /// - Parameter bufferFrame: CGRect frame that outlines the buffer frame
    func deleteObjects() {
        self.children.forEach { node in
            let pos = self.convertPoint(toView: node.position);
            if (!self.bufferFrame!.contains(pos)) {
                node.removeFromParent()
            }
        }
    }
    
    // Update score
    func updateScore(name: String) {
        if name.contains("yarn") { scoreValue += 10 }
        else { scoreValue -= 30 }
        scoreLabel.text = "Score: \(scoreValue)"
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Spawn objects into scene
        let intTime = Int(currentTime)
        if (intTime % 2 == 0 && (lastTimeObjSpawned == nil || lastTimeObjSpawned! < intTime)) {
            lastTimeObjSpawned = intTime
            addWholeYarnToSceneWithRandomization()
        }
        deleteObjects(); // Delete objects that go out of frame
    }
}
