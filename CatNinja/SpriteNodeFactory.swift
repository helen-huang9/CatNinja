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
    var scale: CGFloat
    
    init(pos: CGPoint, velocity: CGVector, imgName: String, scale: CGFloat) {
        self.pos = pos
        self.velocity = velocity
        self.imgName = imgName
        self.scale = scale
    }
}

extension GameScene {
    /// A whole yarn into the scene
    func addWholeYarnToSceneWithRandomization() {
        let pos = getRandPointInScene()
        let yarn = Sprite(pos: pos, velocity: getRandVelocityTowardsCenterOfScene(pos: pos), imgName: "Yarn_Pixel_Art", scale: 3.0)
        addSpriteToScene(obj: yarn)
    }
    
    func addSpriteToScene(obj: Sprite) {
        let spriteNode = SKSpriteNode(imageNamed: obj.imgName)
        spriteNode.name = obj.imgName
        spriteNode.setScale(obj.scale)
        spriteNode.position = obj.pos
        spriteNode.physicsBody = SKPhysicsBody(texture: self.spriteAtlas.textureNamed(obj.imgName), size: spriteNode.size)
        spriteNode.physicsBody!.velocity = obj.velocity
        spriteNode.physicsBody!.collisionBitMask = 0x0 // prevents collision with other sprites
        self.addChild(spriteNode)
    }
    
    /// Returns a random point in the scene's frame
    /// - Returns: CGPoint representing a random point within the scene's frame and buffer
    func getRandPointInScene() -> CGPoint {
        let location = Int.random(in: 0...3)
        let buffer = 20.0
        var randPt: CGPoint?
        switch location {
        case 0: // Left
            randPt = CGPoint(x: Double.random(in: (self.frame.minX - buffer)...self.frame.minX),
                             y: Double.random(in: (self.frame.minY + buffer)...(self.frame.maxY - buffer)))
        case 1: // Right
            randPt = CGPoint(x: Double.random(in: (self.frame.maxX - buffer)...self.frame.maxX),
                             y: Double.random(in: (self.frame.minY + buffer)...(self.frame.maxY - buffer)))
        case 2: // Top
            randPt = CGPoint(x: Double.random(in: (self.frame.minX + buffer)...(self.frame.maxX - buffer)),
                             y: Double.random(in: (self.frame.minY)...(self.frame.minY + buffer)))
        default: // Bottom
            randPt = CGPoint(x: Double.random(in: (self.frame.minX + buffer)...(self.frame.maxX - buffer)),
                             y: Double.random(in: (self.frame.maxY - buffer)...(self.frame.maxY)))
        }
        return randPt!
    }
    
    
    /// Given a point in the scene, returns a velocity in the general direction of the center of the scene. The velocity will have slight noise.
    /// - Parameter pos: CGPoint point in the scene
    /// - Returns: CGVector representing a velocity that points to the center of the scene
    func getRandVelocityTowardsCenterOfScene(pos: CGPoint) -> CGVector {
        var velocity = CGVector(dx: 0.0 - pos.x, dy: 0.0 - pos.y)
        velocity.dx += Double.random(in: -10.0...10.0)
        velocity.dy += Double.random(in: -10.0...10.0)
        velocity.dx *= 1.2
        velocity.dy *= 1.2
        return velocity
    }
}
