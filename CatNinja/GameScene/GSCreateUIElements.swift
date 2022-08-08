//
//  Configurations.swift
//  CatNinja
//
//  Created by Helen Huang on 7/15/22.
//

import SpriteKit

extension GameScene {
    
    func createBackground() {
        self.background.size = CGSize(width: 1000, height: 1000)
        self.background.position = CGPoint(x: frame.midX + 35, y:frame.midY)
        self.background.blendMode = .replace
        self.addChild(background)
    }
    
    func createScoreLabel() {
        self.scoreLabel.text = "\(self.scoreValue)"
        self.scoreLabel.verticalAlignmentMode = .top
        self.scoreLabel.horizontalAlignmentMode = .left
        self.scoreLabel.fontColor = .black
        self.scoreLabel.fontName = self.font
        self.scoreLabel.position = CGPoint(x: frame.minX + 65, y: frame.maxY - 35.0)
        self.scoreLabel.fontSize = 36
        self.scoreLabel.blendMode = .replace
        self.addChild(self.scoreLabel)
    }
    
    func createHighScoreLabel() {
        let highscoreVal = UserDefaults.standard.integer(forKey: "high_score")
        let highscoreLabel = SKLabelNode(text: "High score: \(highscoreVal)")
        highscoreLabel.verticalAlignmentMode = .top
        highscoreLabel.horizontalAlignmentMode = .left
        highscoreLabel.fontColor = .black
        highscoreLabel.fontName = self.font
        highscoreLabel.position = CGPoint(x: frame.minX + 13, y: frame.maxY - 75.0)
        highscoreLabel.fontSize = 16
        highscoreLabel.blendMode = .replace
        self.addChild(highscoreLabel)
    }
    
    func createTimerLabel() {
        let clock = SKSpriteNode(imageNamed: "Clock")
        clock.setScale(0.75)
        clock.position = CGPoint(x: frame.minX + 20, y: frame.maxY - 102.0)
        self.addChild(clock)
        
        self.timerLabel.text = "\(self.timerValue / 60):\(String(format: "%02d", self.timerValue % 60))"
        self.timerLabel.verticalAlignmentMode = .top
        self.timerLabel.horizontalAlignmentMode = .left
        self.timerLabel.fontColor = .white
        self.timerLabel.fontName = self.font
        self.timerLabel.position = CGPoint(x: frame.minX + 32, y: frame.maxY - 95.0)
        self.timerLabel.fontSize = 18
        self.timerLabel.blendMode = .replace
        self.addChild(self.timerLabel)
    }
    
    func createLivesLabel() {
        self.lives[self.livesValue].position = CGPoint(x: frame.maxX - 45.0, y: frame.maxY - 40.0)
        self.addChild(self.lives[self.livesValue])
    }
    
    func createLossLabel() {
        let lossLabel = SKLabelNode(text: "GAME OVER")
        lossLabel.name = "lossLabel"
        lossLabel.position.y += 50.0
        lossLabel.fontName = self.font
        lossLabel.fontSize = 48
        lossLabel.blendMode = .replace
        self.addChild(lossLabel)
    }
    
    func createFinalScoreLabel() {
        let finalScore = SKLabelNode(text: "Final Score: \(self.scoreValue)")
        if self.scoreValue > UserDefaults.standard.integer(forKey: "high_score") {
            finalScore.text = "✨ New High Score: \(self.scoreValue) ✨"
        }
        finalScore.name = "finalScore"
        finalScore.position.y += 10.0
        finalScore.fontName = self.font
        finalScore.fontSize = 24
        finalScore.blendMode = .replace
        self.addChild(finalScore)
    }
    
    func createGameStartCountdownLabel(label: SKLabelNode) {
        label.position.y += 10.0
        label.fontName = self.font
        label.fontSize = 48
        label.blendMode = .replace
        self.addChild(label)
    }
    
    func createComboLabel(pos: CGPoint) {
        let combo = SKLabelNode(text: "x\(self.combo)")
        combo.fontName = "Chalkduster"
        combo.fontSize = 28
        combo.fontColor = UIColor(red: 1, green: 0.64, blue: 0.3, alpha: 1)
        combo.position = pos
        combo.position.x -= 25
        combo.position.y += 25
        self.addChild(combo)
        let group = SKAction.group([SKAction.fadeOut(withDuration: 1), SKAction.move(by: CGVector(dx: 0, dy: 50), duration: 1)])
        combo.run(SKAction.sequence([group, SKAction.removeFromParent()]))
    }
    
    func createBonusScoreLabel(bonus: Int) {
        let combo = SKLabelNode(text: "+\(bonus) Bonus")
        combo.verticalAlignmentMode = .top
        combo.fontName = "Chalkduster"
        combo.fontSize = 40
        combo.fontColor = UIColor(red: 1, green: 0.64, blue: 0.3, alpha: 1)
        combo.position.y += 250
        self.addChild(combo)
        let group = SKAction.group([SKAction.fadeOut(withDuration: 2), SKAction.move(by: CGVector(dx: 0, dy: 40), duration: 2)])
        combo.run(SKAction.sequence([group, SKAction.removeFromParent()]))
    }
    
    func createParticleEmitterAndSound(node: SKSpriteNode) {
        if let emitter = SKEmitterNode(fileNamed: "spark") {
            let sound = node.name!.contains("Bomb") ? self.glassBreakSound : self.spriteBreakSound

            emitter.position = node.position
            emitter.particleColorSequence = nil
            emitter.particleColor = node.color
            self.addChild(emitter)

            let wait = SKAction.wait(forDuration: emitter.particleLifetime)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([sound, wait, remove])
            emitter.run(sequence)
        }
    }
    
    func drawClaw(start: CGPoint, end: CGPoint) {
        let path = CGMutablePath()
        path.move(to: start)
        path.addLine(to: end)
        let claw = SKShapeNode(path: path)
        claw.lineWidth = 4
        claw.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), SKAction.removeFromParent()]))
        self.addChild(claw)
    }
    
    func flashScreenRed() {
        let pulseRed = SKAction.sequence([
            SKAction.colorize(with: .red, colorBlendFactor: 0.4, duration: 0.15),
            SKAction.wait(forDuration: 0.1),
            SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.15)
        ])
        self.background.run(pulseRed)
    }
}
