//
//  GameSceneGamePlay.swift
//  CatNinja
//
//  Created by Helen Huang on 7/25/22.
//

import SpriteKit

enum TouchState {
    case began
    case moved
    case ended
}

extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        explodeTouchedSprites(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        clawSlice(touches: touches)
        explodeTouchedSprites(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateComboScore()
    }

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
    
    func clawSlice(touches: Set<UITouch>) {
        if self.gameStatus == GameState.isPlaying {
            guard let touch = touches.first else { return }
            let currLocation = touch.location(in: self)
            let prevLocation = touch.previousLocation(in: self)
            drawClaw(start: currLocation, end: prevLocation)
        }
    }
    
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
    
    func updateCombo(name: String) {
        if name.contains("Bomb") {
            updateComboScore()
        } else {
            self.combo += 1
        }
    }
    
    func updateComboScore() {
        if self.combo > 2 {
            let bonus = self.combo * 20
            self.scoreValue += bonus
            self.scoreLabel.text = "\(self.scoreValue)"
            createBonusScoreLabel(bonus: bonus)
        }
        self.combo = 0
    }
    
    func updateTime(name: String) {
        if name.contains("Treat") {
            timerValue += 10
            timerLabel.text = "\(self.timerValue / 60):\(String(format: "%02d", self.timerValue % 60))"
        }
    }
    
    func updateScore(name: String) {
        if name.contains("Ball") { scoreValue += 30 }
        else if name.contains("Toy") { scoreValue += 50 }
        scoreLabel.text = "\(scoreValue)"
    }
    
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
    
    func checkForEndCondition() {
        if ((self.livesValue <= 0 || self.timerValue < 0) && self.gameStatus != GameState.end) {
            self.gameStatus = GameState.end
            self.removeAction(forKey: "spawnSprites")
            self.removeAction(forKey: "timer")
            showEndScreen()
        }
    }
}
