//
//  NodeFactory.swift
//  CatNinja
//
//  Created by Helen Huang on 2/12/22.
//

import SpriteKit
 
/// The sides of the screen.
enum ScreenSide: CaseIterable {
    case left
    case right
    case top
    case bottom
}

/// Spawn rates of all the tappable sprites.
enum SpawnRateRange {
    static let ballRate = 1...40
    static let toyRate = 41...70
    static let bombRate = 71...95
    static let treatRate = 96...100
}

extension GameScene {
    /// Creates and runs an SKAction that spawns a random tappable sprites into the GameScene every 0.9 seconds.
    /// The spawned sprites have random initial positions out of frame with random initial velocities that generally point
    /// towards the center of the screen.
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
    
    /// Creates and runs an SKAction that deletes tappable sprites out of the buffer frame every second.
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
    
    /// Creates a tappable sprite with a random initial position and velocity and adds it to the GameScene.
    /// - Parameter num: An int within [1, 100] that determines which sprite to create based on the SpawnRateRange.
    func addSpriteToSceneWithRandomization(num: Int) {
        var index: Int?
        switch num {
        case SpawnRateRange.ballRate:
            index = Int.random(in: 0...2) // Blue, Pink, Orange
        case SpawnRateRange.toyRate:
            index = Int.random(in: 3...5) // Mouse, Feather, Butterfly
        case SpawnRateRange.bombRate:
            index = 6 // Bomb
        case SpawnRateRange.treatRate:
            index = 7 // Treat
        default:
            return
        }
        
        let posDir = getRandPointAndDirInScene()
        let vel = getRandVelocityTowardsCenterOfScene(posDir: posDir)
        let imgName = self.spriteNames[index!]
        let color = self.spriteColors[index!]
        addSpriteToScene(pos: posDir.pos, velocity: vel, imgName: imgName, texColor: color, scale: 3.0)
    }

    /// Initializes an SKSpriteNode with the inputted parameters and a physicsBody and adds it to the GameScene.
    ///  If the sprite is a Bomb or Treat, add a child SKEmitterNode to the SKSpriteNode for particle effects.
    /// - Parameters:
    ///   - pos: Initial position of the SKSpriteNode.
    ///   - velocity: Initial velocity of the SKSpriteNode.
    ///   - imgName: File name of the sprite image.
    ///   - texColor: Base color of the sprite. Used for particle effects.
    ///   - scale: How much to scale the size of the SKSpriteNode by.
    func addSpriteToScene(pos: CGPoint, velocity: CGVector, imgName: String, texColor: UIColor, scale: CGFloat) {
        let spriteNode = SKSpriteNode(texture: self.spriteAtlas.textureNamed(imgName))
        spriteNode.color = texColor
        spriteNode.name = imgName
        spriteNode.setScale(scale)
        spriteNode.position = pos
        spriteNode.physicsBody = SKPhysicsBody(texture: self.spriteAtlas.textureNamed(imgName), size: spriteNode.size)
        spriteNode.physicsBody!.velocity = velocity
        spriteNode.physicsBody!.angularVelocity = CGFloat.random(in: -3.0...3.0)
        spriteNode.physicsBody!.collisionBitMask = 0x0 // prevents collision with other sprites
        
        if (imgName.contains("Bomb")) {
            if let emitter = SKEmitterNode(fileNamed: "smoke") {
                emitter.name = "smoke"
                emitter.isUserInteractionEnabled = false
                spriteNode.addChild(emitter)
            }
        } else if (imgName.contains("Treat")) {
            if let emitter = SKEmitterNode(fileNamed: "magic") {
                emitter.isUserInteractionEnabled = false
                spriteNode.addChild(emitter)
            }
        }
        self.addChild(spriteNode)
    }
    
    /// Returns a tuple of a random point off-screen and the corresponding ScreenSide the point is located.
    /// - Returns: A random point off-screen and the corresponding ScreenSide.
    func getRandPointAndDirInScene() -> (pos: CGPoint, dir: ScreenSide) {
        let dir = ScreenSide.allCases.randomElement()!
        let buffer = 30.0
        var randPt: CGPoint?
        switch dir {
        case ScreenSide.left:
            randPt = CGPoint(x: self.frame.minX - 10,
                             y: Double.random(in: (self.frame.minY + buffer)...(self.frame.maxY - buffer)))
        case ScreenSide.right:
            randPt = CGPoint(x: self.frame.maxX + 10,
                             y: Double.random(in: (self.frame.minY + buffer)...(self.frame.maxY - buffer)))
        case ScreenSide.top:
            randPt = CGPoint(x: Double.random(in: (self.frame.minX + buffer)...(self.frame.maxX - buffer)),
                             y: self.frame.maxY + 10)
        case ScreenSide.bottom:
            randPt = CGPoint(x: Double.random(in: (self.frame.minX + buffer)...(self.frame.maxX - buffer)),
                             y: self.frame.minY - 10)
        }
        return (randPt!, dir)
    }
    
    /// Returns a random vector that points to the middle of the screen with some noise added. The magnitude is dependent on the value
    ///  of the current GameScene.scoreValue. Used for setting the initial velocity of a tappable SKSpriteNode.
    /// - Parameter posDir: A tuple containing a point off-screen with its corresponding ScreenSide direction.
    /// - Returns: CGVector pointing in the general direction of the middle of the screen.
    func getRandVelocityTowardsCenterOfScene(posDir: (pos: CGPoint, dir: ScreenSide)) -> CGVector {
        var noiseMagX: Double?
        var noiseMagY: Double?
        switch (posDir.dir) {
        case ScreenSide.left, ScreenSide.right:
            noiseMagX = 20
            noiseMagY = self.frame.height / 3
        case ScreenSide.top, ScreenSide.bottom:
            noiseMagX = self.frame.width / 3
            noiseMagY = 20
        }
        
        let noiseX = Double.random(in: -noiseMagX!...noiseMagX!)
        let noiseY = Double.random(in: -noiseMagY!...noiseMagY!)
        var velocity = CGVector(dx: noiseX - posDir.pos.x, dy: noiseY - posDir.pos.y)
        let speedIncrease = CGFloat(self.scoreValue)/10000.0
        velocity.dx *= 1.2 + speedIncrease
        velocity.dy *= 1.2 + speedIncrease
        return velocity
    }
}
