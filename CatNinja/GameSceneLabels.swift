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
        self.scoreLabel.text = "\(self.scoreValue)"
        self.scoreLabel.verticalAlignmentMode = .top
        self.scoreLabel.horizontalAlignmentMode = .left
        self.scoreLabel.fontColor = .black
        self.scoreLabel.fontName = self.font
        
        self.scoreLabel.position = CGPoint(x: frame.minX + 65, y: frame.maxY - 35.0)
        self.addChild(self.scoreLabel)
    }
    
    func createTimerLabel() {
        self.timerLabel.text = "\(self.timerValue / 60):\(String(format: "%02d", self.timerValue % 60))"
        self.timerLabel.verticalAlignmentMode = .top
        self.timerLabel.horizontalAlignmentMode = .left
        self.timerLabel.fontColor = .white
        self.timerLabel.fontName = self.font
        
        self.timerLabel.position = CGPoint(x: frame.minX + 20, y: frame.maxY - 75.0)
        self.timerLabel.fontSize = 18
        self.addChild(self.timerLabel)
    }
    
    func createLivesLabel() {
        self.livesLabel.text = "x\(self.livesValue)"
        self.livesLabel.verticalAlignmentMode = .top
        self.livesLabel.horizontalAlignmentMode = .right
        self.livesLabel.fontColor = .white
        self.livesLabel.fontName = self.font
        
        self.livesLabel.position = CGPoint(x: frame.maxX - 30.0, y: frame.maxY - 30.0)
        self.livesLabel.fontSize = 24
        self.addChild(self.livesLabel)
    }
    
    func createLossLabel() {
        let lossLabel = SKLabelNode(text: "GAME OVER")
        lossLabel.name = "lossLabel"
        lossLabel.position.y += 50.0
        lossLabel.fontName = self.font
        lossLabel.fontSize = 48
        self.addChild(lossLabel)
    }
    
    func createFinalScoreLabel() {
        let finalScore = SKLabelNode(text: "Final Score: \(self.scoreValue)")
        finalScore.name = "finalScore"
        finalScore.position.y += 10.0
        finalScore.fontName = self.font
        finalScore.fontSize = 24
        self.addChild(finalScore)
    }
    
    func positionAndAddGameStartCountdownLabel(label: SKLabelNode) {
        label.position.y += 10.0
        label.fontName = self.font
        label.fontSize = 48
        self.addChild(label)
    }
}
