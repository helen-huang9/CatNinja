//
//  NodeFactory.swift
//  CatNinja
//
//  Created by Helen Huang on 2/12/22.
//

import SpriteKit

func addYarnToSceneWithRandomization(scene: SKScene) {
    let pos = getRandPointInScene(scene: scene)
    combineAndAddFragsToScene(pos: pos, vel: getRandVelocityTowardsCenterOfScene(pos: pos), imgName1: "yarn-half-2", anchor1: CGPoint(x: 0.5, y: 0), scale: 0.2, imgName2: "yarn-half-1", anchor2: CGPoint(x: 0.5, y: 1), scene: scene)
}

func addSardineToSceneWithRandomization(scene: SKScene) {
    let pos = getRandPointInScene(scene: scene)
    combineAndAddFragsToScene(pos: pos, vel: getRandVelocityTowardsCenterOfScene(pos: pos), imgName1: "sardine_first_half", anchor1: CGPoint(x: 1, y: 0.5), scale: 0.2, imgName2: "sardine_second_half", anchor2: CGPoint(x: 0, y: 0.5), scene: scene)
}

func addBottleToSceneWithRandomization(scene: SKScene) {
    let pos = getRandPointInScene(scene: scene)
    combineAndAddFragsToScene(pos: pos, vel: getRandVelocityTowardsCenterOfScene(pos: pos), imgName1: "spray_bottle_top_half", anchor1: CGPoint(x: 0.5, y: 0), scale: 0.2, imgName2: "spray_bottle_bottom_half", anchor2: CGPoint(x: 0.50, y: 0.38), scene: scene)
}

func combineAndAddFragsToScene(pos: CGPoint, vel: CGVector, imgName1: String, anchor1: CGPoint, scale: CGFloat, imgName2: String, anchor2: CGPoint, scene: SKScene) {
    // Create first half
    let firstHalf = SKSpriteNode(imageNamed: imgName1)
    firstHalf.name = "first half"
    firstHalf.setScale(scale)
    firstHalf.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: imgName1), size: firstHalf.size)
    firstHalf.anchorPoint = anchor1
    firstHalf.position = pos
    firstHalf.physicsBody!.velocity = vel
    firstHalf.physicsBody!.restitution = 1.0
    
    // Create second half
    let secondHalf = SKSpriteNode(imageNamed: imgName2)
    secondHalf.name = "second half"
    secondHalf.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: imgName2), size: secondHalf.size)
    secondHalf.anchorPoint = anchor2
    secondHalf.physicsBody!.velocity = vel
    
    // Make second half a child of first half
    scene.addChild(firstHalf)
    firstHalf.addChild(secondHalf)
    
    // Add second half to first half with a joint
    let mid = CGPoint(x: 0, y: 0)
    let firstHalfJoint = SKPhysicsJointFixed.joint(withBodyA: firstHalf.physicsBody!, bodyB: secondHalf.physicsBody!, anchor: mid)
    
    // Add the joint to physics world
    scene.physicsWorld.add(firstHalfJoint)
}

func getRandPointInScene(scene: SKScene) -> CGPoint {
    let location = Int.random(in: 0...3)
    let buffer = 20.0
    var randPt: CGPoint?
    switch location {
    case 0: // Left
        randPt = CGPoint(x: Double.random(in: (scene.frame.minX - buffer)...scene.frame.minX),
                         y: Double.random(in: (scene.frame.minY + buffer)...(scene.frame.maxY - buffer)))
    case 1: // Right
        randPt = CGPoint(x: Double.random(in: (scene.frame.maxX - buffer)...scene.frame.maxX),
                         y: Double.random(in: (scene.frame.minY + buffer)...(scene.frame.maxY - buffer)))
    case 2: // Top
        randPt = CGPoint(x: Double.random(in: (scene.frame.minX + buffer)...(scene.frame.maxX - buffer)),
                         y: Double.random(in: (scene.frame.minY)...(scene.frame.minY + buffer)))
    default: // Bottom
        randPt = CGPoint(x: Double.random(in: (scene.frame.minX + buffer)...(scene.frame.maxX - buffer)),
                         y: Double.random(in: (scene.frame.maxY - buffer)...(scene.frame.maxY)))
    }
    return randPt!
}

func getRandVelocityTowardsCenterOfScene(pos: CGPoint) -> CGVector {
    var velocity = CGVector(dx: 0.0 - pos.x, dy: 0.0 - pos.y)
    velocity.dx += Double.random(in: -10.0...10.0)
    velocity.dy += Double.random(in: -10.0...10.0)
    velocity.dx *= 0.5
    velocity.dy *= 0.5
    print("Velocity:", velocity)
    return velocity
}
