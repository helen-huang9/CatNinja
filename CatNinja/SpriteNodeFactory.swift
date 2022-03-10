//
//  NodeFactory.swift
//  CatNinja
//
//  Created by Helen Huang on 2/12/22.
//

import SpriteKit

/// Defines a set of components needed to create a sliceable bject (e.g. yarn, sardine, spraybottle)
struct SliceableObject {
    var pos: CGPoint /// Position in the scene where the SliceableObject will spawn
    var velocity: CGVector /// Initial velocity of SliceableObject
    var imgName1: String /// Image name of top/first half of object
    var anchor1: CGPoint /// Position of imgName1's anchor
    var imgName2: String /// Image name of bottom/second half of object
    var anchor2: CGPoint /// Position of imgName2's anchor
    var scale: CGFloat /// Size of SliceableObject
    init(pos: CGPoint, velocity: CGVector, imgName1: String, anchor1: CGPoint, imgName2: String, anchor2: CGPoint, scale: CGFloat) {
        self.pos = pos
        self.velocity = velocity
        self.imgName1 = imgName1
        self.anchor1 = anchor1
        self.imgName2 = imgName2
        self.anchor2 = anchor2
        self.scale = scale
    }
}

extension GameScene {
    /// Spawns a yarn SliceableObject into the scene
    func addYarnToSceneWithRandomization() {
        let pos = getRandPointInScene()
        let yarn = SliceableObject(pos: pos,
                                   velocity: getRandVelocityTowardsCenterOfScene(pos: pos),
                                   imgName1: "yarn-half-2", anchor1: CGPoint(x: 0.5, y: 0),
                                   imgName2: "yarn-half-1", anchor2: CGPoint(x: 0.5, y: 1),
                                   scale: 0.2)
        combineAndAddFragsToScene(sliceableObj: yarn)
    }
    
    /// Spawns a sardine SliceableObject into the scene
    func addSardineToSceneWithRandomization() {
        let pos = getRandPointInScene()
        let sardine = SliceableObject(pos: pos,
                                      velocity: getRandVelocityTowardsCenterOfScene(pos: pos),
                                      imgName1: "sardine_first_half", anchor1: CGPoint(x: 1, y: 0.5),
                                      imgName2: "sardine_second_half", anchor2: CGPoint(x: 0, y: 0.5),
                                      scale: 0.2)
        combineAndAddFragsToScene(sliceableObj: sardine)
    }
    
    /// Spawns a spray bottle SliceableObject into the scene
    func addBottleToSceneWithRandomization() {
        let pos = getRandPointInScene()
        let sprayBottle = SliceableObject(pos: pos,
                                          velocity: getRandVelocityTowardsCenterOfScene(pos: pos),
                                          imgName1: "spray_bottle_top_half", anchor1: CGPoint(x: 0.5, y: 0),
                                          imgName2: "spray_bottle_bottom_half", anchor2: CGPoint(x: 0.50, y: 0.38),
                                          scale: 0.2)
        combineAndAddFragsToScene(sliceableObj: sprayBottle)
    }
    
    
    /// Assembles the components specified in SliceableObject to create two SKNodes that represent the two halfs of a SliceableObject. It assembles both the visual and physics aspects
    /// of the SliceableObject. The second SKNode is the child of the first SKNode, and the first SKNode is the child of the scene.
    /// - Parameters:
    ///   - sliceableObj: a SliceableObject (e.g. yarn, sardine, or spray bottle)
    func combineAndAddFragsToScene(sliceableObj: SliceableObject) {
        // Create the first SKNode (represented as the top/first image of SliceableObject)
        let firstHalf = SKSpriteNode(imageNamed: sliceableObj.imgName1)
        firstHalf.name = sliceableObj.imgName1
        firstHalf.setScale(sliceableObj.scale)
        firstHalf.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: sliceableObj.imgName1), size: firstHalf.size)
        firstHalf.anchorPoint = sliceableObj.anchor1
        firstHalf.position = sliceableObj.pos
        firstHalf.physicsBody!.velocity = sliceableObj.velocity
        firstHalf.physicsBody!.restitution = 1.0
        
        // Create the second SKNode (represented as the bottom/second image of SliceableObject)
        let secondHalf = SKSpriteNode(imageNamed: sliceableObj.imgName2)
        secondHalf.name = sliceableObj.imgName2
        secondHalf.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: sliceableObj.imgName2), size: secondHalf.size)
        secondHalf.anchorPoint = sliceableObj.anchor2
        secondHalf.physicsBody!.velocity = sliceableObj.velocity
        
        // Make second half a child of first half
        self.addChild(firstHalf)
        firstHalf.addChild(secondHalf)
        
        // Add second half to first half with a joint
        let mid = CGPoint(x: 0, y: 0)
        let firstHalfJoint = SKPhysicsJointFixed.joint(withBodyA: firstHalf.physicsBody!, bodyB: secondHalf.physicsBody!, anchor: mid)
        
        // Add the joint to physics world
        self.physicsWorld.add(firstHalfJoint)
    }
    
    
    /// Returns a random point in the scene's frame
    /// - Returns: CGPoint representing a random point in the scene
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
        velocity.dx *= 0.5
        velocity.dy *= 0.5
        return velocity
    }
}
