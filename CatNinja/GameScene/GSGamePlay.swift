//
//  GameSceneGamePlay.swift
//  CatNinja
//
//  Created by Helen Huang on 7/25/22.
//

import SpriteKit

extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        checkForEndCondition()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        explodeTouchedSprites(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        clawSlice(touches: touches)
        explodeTouchedSprites(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        endCombo()
    }

    /// Creates and runs the SKAction in charge of counting-down the game scene timer.
    func beginTimer() {
        let block = SKAction.run {
            if (self.timerValue <= 10) {
                self.timerLabel.fontColor = UIColor(red: 0.8, green: 0.08, blue: 0.07, alpha: 1.0)
            } else {
                self.timerLabel.fontColor = .white
            }
            self.timerLabel.text = "\(self.timerValue / 60):\(String(format: "%02d", self.timerValue % 60))"
            self.timerValue -= 1
        }
        let wait = SKAction.wait(forDuration: 1)
        let sequence = SKAction.sequence([block, wait])
        self.run(SKAction.repeatForever(sequence), withKey: "timer")
    }
    
    /// Draws the claw shapes paths where the user swipes the screen.
    /// - Parameters:
    ///   - start: The starting point of the path to draw.
    ///   - end: The end point of the path to draw.
    func clawSlice(touches: Set<UITouch>) {
        if self.gameStatus == GameState.isPlaying {
            guard let touch = touches.first else { return }
            let start = touch.location(in: self)
            let end = touch.previousLocation(in: self)
            let path = CGMutablePath()
            path.move(to: start)
            path.addLine(to: end)
            let claw = SKShapeNode(path: path)
            claw.lineWidth = 4
            claw.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), SKAction.removeFromParent()]))
            self.addChild(claw)
        }
    }
    
    /// Iterates through all touched sprites and destroys it. Updates any relevant game info like the score, llives, time, etc.
    func explodeTouchedSprites(touches: Set<UITouch>) {
        if self.gameStatus == GameState.isPlaying {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            let touchedNodes = nodes(at: location)
            
            touchedNodes.forEach { node in
                if let spriteNode = node as? SKSpriteNode {
                    if let name = spriteNode.name {
                        updateCombo(name: name)
                        updateScore(name: name)
                        updateLives(name: name)
                        updateTime(name: name)
                        explodeSprite(node: spriteNode)
                    }
                }
            }
        }
    }
    
    
    /// Deletes the inputted node and plays its destroy particle effect and sound in place of it.
    /// - Parameter node: The SKSpriteNode to be removed from the game scene.
    func explodeSprite(node: SKSpriteNode) {
        createParticleEmitterAndSound(node: node)
        if self.combo > 2 && !node.name!.contains("Bomb") {
            createComboLabel(pos: node.position)
        }
        if node.name!.contains("Treat") {
            createTreatAddTimeLabel(pos: node.position)
        }
        node.removeFromParent()
    }
    
    /// Updates the combo.
    func updateCombo(name: String) {
        if name.contains("Bomb") {
            endCombo()
        } else {
            self.combo += 1
        }
    }
    
    /// Ends the combo and updates the score value.
    func endCombo() {
        if self.combo > 2 {
            let bonus = self.combo * 20
            self.scoreValue += bonus
            self.scoreLabel.text = "\(self.scoreValue)"
            createBonusScoreLabel(bonus: bonus)
        }
        self.combo = 0
    }
    
    /// Updates the time if any time-related sprites are destroyed.
    /// - Parameter name: The name of the sprite to check.
    func updateTime(name: String) {
        if name.contains("Treat") {
            timerValue += 10
            timerLabel.text = "\(self.timerValue / 60):\(String(format: "%02d", self.timerValue % 60))"
        }
    }
    
    /// Updates the time if any score-related sprites are destroyed.
    /// - Parameter name: The name of the sprite to check.
    func updateScore(name: String) {
        if name.contains("Ball") { scoreValue += 30 }
        else if name.contains("Toy") { scoreValue += 50 }
        scoreLabel.text = "\(scoreValue)"
    }
    
    /// Updates the lives if any life-related sprites are destroyed.
    /// - Parameter name: The name of the sprite to check.
    func updateLives(name: String) {
        if name.contains("Bomb") {
            self.lives[self.livesValue].removeFromParent()
            livesValue -= 1
            let livesIndex = max(self.livesValue, 0)
            self.lives[livesIndex].position = CGPoint(x: frame.maxX - 45.0, y: frame.maxY - 40.0)
            self.addChild(self.lives[livesIndex])
            flashScreenRed()
        }
    }
    
    /// Check for the end condition, which is when either the timer or the number of lives left reaches 0.
    func checkForEndCondition() {
        if ((self.livesValue <= 0 || self.timerValue < 0) && self.gameStatus != GameState.end) {
            self.gameStatus = GameState.end
            self.removeAction(forKey: "spawnSprites")
            self.removeAction(forKey: "timer")
            showEndScreen()
        }
    }
}
