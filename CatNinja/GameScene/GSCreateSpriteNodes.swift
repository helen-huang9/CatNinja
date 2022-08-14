//
//  NodeFactory.swift
//  CatNinja
//
//  Created by Helen Huang on 2/12/22.
//

import SpriteKit

enum Direction: CaseIterable {
    case left
    case right
    case top
    case bottom
}

struct Sprite {
    var pos: CGPoint
    var velocity: CGVector
    var imgName: String
    var texColor: UIColor
    var scale: CGFloat
    
    init(pos: CGPoint, velocity: CGVector, imgName: String, texColor: UIColor, scale: CGFloat) {
        self.pos = pos
        self.velocity = velocity
        self.imgName = imgName
        self.texColor = texColor
        self.scale = scale
    }
}

extension GameScene {
    func continuouslySpawnSprites() {
        let block = SKAction.run {
            for _ in 0...Int.random(in: 0...1) {
                self.addSpriteToSceneWithRandomization(num: Int.random(in: 1...100))
            }
        }
        let wait = SKAction.wait(forDuration: 0.9)
        let sequence = SKAction.sequence([block, wait])
        self.run(SKAction.repeatForever(sequence), withKey: "spawnSprites")
    }
    
    func continuouslyDeleteSpritesOutOfFrame() {
        let remove = SKAction.run {
            self.children.forEach { node in
                let pos = self.convertPoint(toView: node.position);
                if (!self.bufferFrame!.contains(pos)) {
                    node.removeFromParent()
                }
            }
        }
        let wait = SKAction.wait(forDuration: 1)
        let sequence = SKAction.sequence([wait, remove])
        self.run(SKAction.repeatForever(sequence), withKey: "removeSprites")
    }
    
    
    func addSpriteToSceneWithRandomization(num: Int) {
        var index: Int?
        switch num {
        case 1...40: /// 40%
            index = Int.random(in: 0...2) // Yellow, Red, Yarn
        case 41...70: /// 30%
            index = Int.random(in: 3...5) // Mouse, Feather, Butterfly
        case 71...95: /// 25%
            index = 6 // Bomb
        default: /// 5%
            index = 7 // Treat
        }
        
        let pos = getRandPointInScene()
        let vel = getRandVelocityTowardsCenterOfScene(pos: pos)
        let sprite = Sprite(pos: pos, velocity: vel, imgName: self.spriteNames[index!], texColor: self.spriteColors[index!], scale: 3.0)
        addSpriteToScene(obj: sprite)
    }
    
    
    func addSpriteToScene(obj: Sprite) {
        let spriteNode = SKSpriteNode(texture: self.spriteAtlas.textureNamed(obj.imgName))
        spriteNode.color = obj.texColor
        spriteNode.name = obj.imgName
        spriteNode.setScale(obj.scale)
        spriteNode.position = obj.pos
        spriteNode.physicsBody = SKPhysicsBody(texture: self.spriteAtlas.textureNamed(obj.imgName), size: spriteNode.size)
        spriteNode.physicsBody!.velocity = obj.velocity
        spriteNode.physicsBody!.angularVelocity = CGFloat.random(in: -3.0...3.0)
        spriteNode.physicsBody!.collisionBitMask = 0x0 // prevents collision with other sprites
        
        if (obj.imgName.contains("Bomb")) {
            if let emitter = SKEmitterNode(fileNamed: "smoke") {
                emitter.name = "smoke"
                emitter.isUserInteractionEnabled = false
                spriteNode.addChild(emitter)
            }
        } else if (obj.imgName.contains("Treat")) {
            if let emitter = SKEmitterNode(fileNamed: "magic") {
                emitter.isUserInteractionEnabled = false
                spriteNode.addChild(emitter)
            }
        }
        
        self.addChild(spriteNode)
    }
    
    
    func getRandPointInScene() -> CGPoint {
        let location = Direction.allCases.randomElement()!
        let buffer = 30.0
        var randPt: CGPoint?
        switch location {
        case Direction.left:
            randPt = CGPoint(x: self.frame.minX - 10,
                             y: Double.random(in: (self.frame.minY + buffer)...(self.frame.maxY - buffer)))
        case Direction.right:
            randPt = CGPoint(x: self.frame.maxX + 10,
                             y: Double.random(in: (self.frame.minY + buffer)...(self.frame.maxY - buffer)))
        case Direction.top:
            randPt = CGPoint(x: Double.random(in: (self.frame.minX + buffer)...(self.frame.maxX - buffer)),
                             y: self.frame.maxY + 10)
        case Direction.bottom:
            randPt = CGPoint(x: Double.random(in: (self.frame.minX + buffer)...(self.frame.maxX - buffer)),
                             y: self.frame.minY - 10)
        }
        return randPt!
    }
    
    
    func getRandVelocityTowardsCenterOfScene(pos: CGPoint) -> CGVector {
        var noiseMagX: Double?
        var noiseMagY: Double?
        if pos.x < self.frame.minX || pos.x > self.frame.maxX { // pos is on Left or Right sides
            noiseMagX = 20
            noiseMagY = self.frame.height / 3
        } else { // pos is on Top or Bottom sides
            noiseMagX = self.frame.width / 3
            noiseMagY = 20
        }
        
        let noiseX = Double.random(in: -noiseMagX!...noiseMagX!)
        let noiseY = Double.random(in: -noiseMagY!...noiseMagY!)
        
        var velocity = CGVector(dx: noiseX - pos.x, dy: noiseY - pos.y)
        let speedIncrease = CGFloat(self.scoreValue)/10000.0
        velocity.dx *= 1.2 + speedIncrease
        velocity.dy *= 1.2 + speedIncrease
    
        return velocity
    }
}
