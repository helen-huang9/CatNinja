//
//  GameScene.swift
//  CatNinja
//
//  Created by Helen Huang on 1/26/22.
//

import SpriteKit

class GameScene: SKScene {
    
    var scoreLabel = SKLabelNode(text: "0")
    var scoreValue = 0
    var bufferFrame: CGRect?
    let spriteAtlas = SKTextureAtlas(named: "sprites")
    let spriteNames = ["Yarn_Pixel_Art", "Red_Ball_Pixel_Art", "Yellow_Ball_Pixel_Art"]
    
    var lastTimeObjSpawned: Int?
    
    override func didMove(to view: SKView) {
        self.spriteAtlas.preload {}
        deleteAllChildrenAndRespawnUIElements()
        
        // Define buffer frame used for spawning/deleting sprites off screen
        self.bufferFrame = CGRect(x: self.view!.frame.origin.x, y: self.view!.frame.origin.y,
                                  width: self.view!.frame.width + 30.0, height: self.view!.frame.height + 30.0);
    }
    
    override var isUserInteractionEnabled: Bool {
        get { return true } set { }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        touchedNodes.forEach { node in
            if let spriteNode = node as? SKSpriteNode {
                if let name = spriteNode.name {
                    updateScore(name: name)
                    if let emitter = SKEmitterNode(fileNamed: "spark") {
                        emitter.position = spriteNode.position
                        self.addChild(emitter)
                    }
                    spriteNode.removeFromParent()
                }
            }
        }
    }
    
    func deleteAllChildrenAndRespawnUIElements() {
        self.removeAllChildren()
        let background = SKSpriteNode(imageNamed: "CatNinja_Background2")
        background.size = CGSize(width: 1000, height: 1000)
        background.position = CGPoint(x: frame.midX + 35, y:frame.midY)
        self.addChild(background)
        scoreLabel.position = CGPoint(x: frame.minX + 85, y: frame.maxY - 60)
        scoreLabel.fontColor = .black
        scoreLabel.fontName = "SFPro-Black"
        self.addChild(scoreLabel)
    }
    
    func deleteObjectsOutOfFrame() {
        self.children.forEach { node in
            let pos = self.convertPoint(toView: node.position);
            if (!self.bufferFrame!.contains(pos)) {
                node.removeFromParent()
            }
        }
    }
    
    func updateScore(name: String) {
        if name.contains("Yarn") { scoreValue += 100 }
        else if name.contains("Yellow") { scoreValue += 20 }
        else if name.contains("Red") { scoreValue -= 50 }
        scoreLabel.text = "\(scoreValue)"
    }
    
    override func update(_ currentTime: TimeInterval) {
        let intTime = Int(currentTime)
        if (intTime % 2 == 0 && (lastTimeObjSpawned == nil || lastTimeObjSpawned! < intTime)) {
            lastTimeObjSpawned = intTime
            addSpriteToSceneWithRandomization(num: Int.random(in: 0..<self.spriteNames.count))
        }
        deleteObjectsOutOfFrame();
    }
}
