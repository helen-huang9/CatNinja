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
    
    func drawClaw(start: CGPoint, end: CGPoint) {
        let path = CGMutablePath()
        path.move(to: start)
        path.addLine(to: end)
        let claw = SKShapeNode(path: path)
        claw.lineWidth = 4
        claw.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), SKAction.removeFromParent()]))
        self.addChild(claw)
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
        // Particle and sound effects
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
        
        // Combo label
        if self.combo > 2 && !node.name!.contains("Bomb") {
            let combo = SKLabelNode(text: "x\(self.combo)")
            combo.fontName = "Chalkduster"
            combo.fontSize = 28
            combo.fontColor = UIColor(red: 1, green: 0.64, blue: 0.3, alpha: 1)
            combo.position = node.position
            combo.position.x -= 25
            combo.position.y += 25
            self.addChild(combo)
            let group = SKAction.group([SKAction.fadeOut(withDuration: 1), SKAction.move(by: CGVector(dx: 0, dy: 50), duration: 1)])
            combo.run(SKAction.sequence([group, SKAction.removeFromParent()]))
        }
        
        // Remove node
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
            let bonus = self.combo * 10
            self.scoreValue += bonus
            self.scoreLabel.text = "\(self.scoreValue)"
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
            
        self.combo = 0
    }
    
    func updateTime(name: String) {
        if name.contains("Treat") {
            timerValue += 10
            timerLabel.text = "\(self.timerValue / 60):\(String(format: "%02d", self.timerValue % 60))"
        }
    }
    
    func updateScore(name: String) {
        if name.contains("Yarn") { scoreValue += 100 }
        else if name.contains("Yellow") { scoreValue += 20 }
        else if name.contains("Red") { scoreValue += 10 }
        scoreLabel.text = "\(scoreValue)"
    }
    
    func updateLives(name: String) {
        if name.contains("Bomb") {
            self.lives[self.livesValue].removeFromParent()
            livesValue -= 1
            self.lives[self.livesValue].position = CGPoint(x: frame.maxX - 45.0, y: frame.maxY - 40.0)
            self.addChild(self.lives[self.livesValue])
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
