//
//  Configurations.swift
//  CatNinja
//
//  Created by Helen Huang on 7/15/22.
//

import SpriteKit

extension GameScene {
    func createBackground() {
        let background = SKSpriteNode(imageNamed: "CatNinja_Background2")
        background.size = CGSize(width: 1000, height: 1000)
        background.position = CGPoint(x: frame.midX + 35, y:frame.midY)
        self.addChild(background)
    }
    
    func createScoreLabel() {
        self.scoreLabel.verticalAlignmentMode = .top
        self.scoreLabel.horizontalAlignmentMode = .left
        self.scoreLabel.position = CGPoint(x: frame.minX + 65, y: frame.maxY - 35.0)
        self.scoreLabel.fontColor = .black
        self.scoreLabel.fontName = "SFPro-Black"
        self.addChild(self.scoreLabel)
    }
    
    func createLivesLabel() {
        self.livesLabel.verticalAlignmentMode = .top
        self.livesLabel.horizontalAlignmentMode = .right
        self.livesLabel.position = CGPoint(x: frame.maxX - 30.0, y: frame.maxY - 30.0)
        self.livesLabel.fontColor = .white
        self.livesLabel.fontName = "SFPro-Black"
        self.livesLabel.fontSize = 24
        self.addChild(self.livesLabel)
    }
    
    func createLossLabel() {
        let lossLabel = SKLabelNode(text: "GAME OVER")
        lossLabel.position.y += 50.0
        lossLabel.fontName = "SFPro-Black"
        lossLabel.fontSize = 48
        self.addChild(lossLabel)
    }
    
    func createFinalScoreLabel() {
        let finalScore = SKLabelNode(text: "Final Score: \(self.scoreValue)")
        finalScore.fontName = "SFPro-Black"
        finalScore.fontSize = 24
        finalScore.position.y += 10.0
        self.addChild(finalScore)
    }
}
