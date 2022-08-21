//
//  Configurations.swift
//  CatNinja
//
//  Created by Helen Huang on 7/15/22.
//

import SpriteKit
import SwiftUI

extension GameScene {
    /// Adds the background image to the game scene.
    func createBackground() {
        let height = self.frame.height
        self.background.size = CGSize(width: height, height: height)
        self.background.position = CGPoint(x: frame.midX + 35, y:frame.midY)
        self.background.blendMode = .replace
        self.addChild(background)
    }
    
    /// Adds the score label  to the game scene.
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
    
    /// Adds the high score label the the game scene.
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
    
    /// Add the timer label to the game scene.
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
    
    /// Adds the lives label to the game scene.
    func createLivesLabel() {
        self.lives[self.livesValue].position = CGPoint(x: frame.maxX - 45.0, y: frame.maxY - 40.0)
        self.addChild(self.lives[self.livesValue])
    }
    
    /// Adds the "GAME OVER" label to the end game scene.
    func createLossLabel() {
        let lossLabel = SKLabelNode(text: "GAME OVER")
        lossLabel.name = "lossLabel"
        lossLabel.position.y += 70.0
        lossLabel.fontName = self.font
        lossLabel.fontSize = 48
        lossLabel.blendMode = .replace
        self.addChild(lossLabel)
    }
    
    /// Adds the final score label to the end game scene.
    func createFinalScoreLabel() {
        let finalScore = SKLabelNode(text: "Final Score: \(self.scoreValue)")
        if self.scoreValue > UserDefaults.standard.integer(forKey: "high_score") {
            finalScore.text = "✨ New High Score: \(self.scoreValue) ✨"
        }
        finalScore.name = "finalScore"
        finalScore.position.y += 30.0
        finalScore.fontName = self.font
        finalScore.fontSize = 24
        finalScore.blendMode = .replace
        self.addChild(finalScore)
    }
    
    /// Adds the countdown label to the beginning of the game scene.
    func createGameStartCountdownLabel() {
        self.gameStartCountdownLabel.position.y += 10.0
        self.gameStartCountdownLabel.fontName = self.font
        self.gameStartCountdownLabel.fontSize = 48
        self.gameStartCountdownLabel.blendMode = .replace
        self.addChild(self.gameStartCountdownLabel)
    }
    
    /// Adds the combo label to the game scene that removes itself from the scene after a second.
    /// - Parameter pos: Position of the label in the game scene.
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
    
    /// Adds the +10 label to the game scene that removes itself from the scene after a second.
    /// - Parameter pos: Position of the label in the game scene.
    func createTreatAddTimeLabel(pos: CGPoint) {
        let time = SKLabelNode(text: "+10⏱")
        time.fontName = "Chalkduster"
        time.fontSize = 20
        time.fontColor = .white
        time.position = pos
        self.addChild(time)
        let group = SKAction.group([SKAction.fadeOut(withDuration: 1), SKAction.move(by: CGVector(dx: 0, dy: 50), duration: 1)])
        time.run(SKAction.sequence([group, SKAction.removeFromParent()]))
    }
    
    /// Adds the bonus score label to the game scene that removes itself from the scene after a two seconds.
    /// - Parameter bonus: The score bonus to be added to the game scene score.
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
    
    /// Creates a particle emitter and plays a sound at the position of the inputted node. Self deletes after completion.
    /// - Parameter node: The SKSpriteNode to be replaced by the SKEmitterNode
    func createParticleEmitterAndSound(node: SKSpriteNode) {
        var emitter: SKEmitterNode?
        if node.name!.contains("Bomb") {
            emitter = SKEmitterNode(fileNamed: "rain")
        } else {
            emitter = SKEmitterNode(fileNamed: "spark")
            emitter!.particleColorSequence = nil
            emitter!.particleColor = node.color
        }
        emitter!.position = node.position
        self.addChild(emitter!)
        
        /// Sequence
        let wait = SKAction.wait(forDuration: emitter!.particleLifetime)
        let remove = SKAction.removeFromParent()
        if node.name!.contains("Bomb") {
            emitter!.run(SKAction.sequence([
                self.waterSplashSound,
                self.yowlSound,
                wait,
                remove
            ]))
        } else if node.name!.contains("Toy") {
            emitter!.run(SKAction.sequence([
                self.spriteBreakSound,
                Int.random(in: 1...2) == 1 ? self.toy1 : self.toy2,
                wait,
                remove
            ]))
        } else {
            emitter!.run(SKAction.sequence([
                self.spriteBreakSound,
                wait,
                remove
            ]))
        }
    }
    
    /// Flashes the background red. Called when the user swipes a bomb.
    func flashScreenRed() {
        let pulseRed = SKAction.sequence([
            SKAction.colorize(with: .red, colorBlendFactor: 0.4, duration: 0.15),
            SKAction.wait(forDuration: 0.1),
            SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.15)
        ])
        self.background.run(pulseRed)
    }
}
