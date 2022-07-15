//
//  NodeFactory.swift
//  CatNinja
//
//  Created by Helen Huang on 2/12/22.
//

import SpriteKit

/// Defines a set of components needed to create a whole object
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
    /// Initialize a Sprite  w/ image texture from indexed self.spriteNames
    func addSpriteToSceneWithRandomization(num: Int) {
        let pos = getRandPointInScene()
        let sprite = Sprite(pos: pos, velocity: getRandVelocityTowardsCenterOfScene(pos: pos),
                            imgName: self.spriteNames[num], texColor: self.spriteColors[num], scale: 3.0)
        addSpriteToScene(obj: sprite)
    }
    
    /// Add inputed Sprite to Scene
    func addSpriteToScene(obj: Sprite) {
        let spriteNode = SKSpriteNode(imageNamed: obj.imgName)
        spriteNode.color = obj.texColor
        spriteNode.name = obj.imgName
        spriteNode.setScale(obj.scale)
        spriteNode.position = obj.pos
        spriteNode.physicsBody = SKPhysicsBody(texture: self.spriteAtlas.textureNamed(obj.imgName), size: spriteNode.size)
        spriteNode.physicsBody!.velocity = obj.velocity
        spriteNode.physicsBody!.angularVelocity = CGFloat.random(in: -3.0...3.0)
        spriteNode.physicsBody!.collisionBitMask = 0x0 // prevents collision with other sprites
        self.addChild(spriteNode)
    }
    
    /// Returns a random point in the scene's frame
    /// - Returns: CGPoint representing a random point within the scene's frame and buffer
    func getRandPointInScene() -> CGPoint {
        let location = Int.random(in: 0...3)
        let buffer = 30.0
        var randPt: CGPoint?
        switch location {
        case 0: // Left
            randPt = CGPoint(x: self.frame.minX,
                             y: Double.random(in: (self.frame.minY + buffer)...(self.frame.maxY - buffer)))
        case 1: // Right
            randPt = CGPoint(x: self.frame.maxX,
                             y: Double.random(in: (self.frame.minY + buffer)...(self.frame.maxY - buffer)))
        case 2: // Top
            randPt = CGPoint(x: Double.random(in: (self.frame.minX + buffer)...(self.frame.maxX - buffer)),
                             y: self.frame.maxY)
        default: // Bottom
            randPt = CGPoint(x: Double.random(in: (self.frame.minX + buffer)...(self.frame.maxX - buffer)),
                             y: self.frame.minY)
        }
        return randPt!
    }
    
    
    /// Given a point in the scene, returns a velocity in the general direction of the center of the scene. The velocity will have slight noise.
    /// - Parameter pos: CGPoint point in the scene
    /// - Returns: CGVector representing a velocity that points to the center of the scene
    func getRandVelocityTowardsCenterOfScene(pos: CGPoint) -> CGVector {
        let magX = self.frame.width / 3
        let magY = self.frame.height / 3
        let noiseX = Double.random(in: -magX...magX)
        let noiseY = Double.random(in: -magY...magY)
        
        var velocity = CGVector(dx: noiseX - pos.x, dy: noiseY - pos.y)
        velocity.dx *= 1.5
        velocity.dy *= 1.5
        return velocity
    }
}
