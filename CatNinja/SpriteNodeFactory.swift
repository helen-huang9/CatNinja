//
//  NodeFactory.swift
//  CatNinja
//
//  Created by Helen Huang on 2/12/22.
//

import SpriteKit

func addYarnToScene(scene: SKScene) {
    combineAndAddFragsToScene(pos: getRandPointInScene(scene: scene), imgName1: "yarn-half-2", anchor1: CGPoint(x: 0.5, y: 0), scale: 0.2,
                              imgName2: "yarn-half-1", anchor2: CGPoint(x: 0.5, y: 1), scene: scene)
}

func addSardineToScene(scene: SKScene) {
    combineAndAddFragsToScene(pos: getRandPointInScene(scene: scene), imgName1: "sardine_first_half", anchor1: CGPoint(x: 1, y: 0.5), scale: 0.2,
                              imgName2: "sardine_second_half", anchor2: CGPoint(x: 0, y: 0.5), scene: scene)
}

func addBottleToScene(scene: SKScene) {
    combineAndAddFragsToScene(pos: getRandPointInScene(scene: scene), imgName1: "spray_bottle_top_half", anchor1: CGPoint(x: 0.5, y: 0), scale: 0.2,
                              imgName2: "spray_bottle_bottom_half", anchor2: CGPoint(x: 0.50, y: 0.38), scene: scene)
}

func combineAndAddFragsToScene(pos: CGPoint, imgName1: String, anchor1: CGPoint, scale: CGFloat, imgName2: String, anchor2: CGPoint, scene: SKScene) {
    let firstHalf = SKSpriteNode(imageNamed: imgName1)
    firstHalf.name = "first half"
    firstHalf.setScale(scale)
    firstHalf.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: imgName1), size: firstHalf.size)
    firstHalf.anchorPoint = anchor1
    firstHalf.position = pos
    
    let secondHalf = SKSpriteNode(imageNamed: imgName2)
    secondHalf.name = "second half"
    secondHalf.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: imgName2), size: secondHalf.size)
    secondHalf.anchorPoint = anchor2
    
    scene.addChild(firstHalf)
    firstHalf.addChild(secondHalf)
    
    let mid = CGPoint(x: 0, y: 0)
    let firstHalfJoint = SKPhysicsJointFixed.joint(withBodyA: firstHalf.physicsBody!, bodyB: secondHalf.physicsBody!, anchor: mid)
    
    scene.physicsWorld.add(firstHalfJoint)
}

func getRandPointInScene(scene: SKScene) -> CGPoint {
    var randFramePt = CGPoint(x: Double.random(in: -200...200),
                              y: Double.random(in: -200...200))
//    randFramePt.x -= scene.frame.midX
//    randFramePt.y -= scene.frame.midY
    return randFramePt
}
