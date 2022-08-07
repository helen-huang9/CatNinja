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
//            drawThreeClaws(currLocation: currLocation, prevLocation: prevLocation)
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
    
    func drawThreeClaws(currLocation: CGPoint, prevLocation: CGPoint) {
        // Parallel
        let paraTemp = simd_float2(x: Float(currLocation.x - prevLocation.x), y: Float(currLocation.y - prevLocation.y))
        var para = simd_normalize(paraTemp)
        para *= 10
        
        // Perpendicular
        let perpTemp = simd_float2(x: Float(currLocation.y - prevLocation.y), y: Float(prevLocation.x - currLocation.x))
        var perp = simd_normalize(perpTemp)
        perp *= 10
        
        // Middle Claw
        var x = CGFloat(para.x)
        var y = CGFloat(para.y)
        let middleStart = CGPoint(x: currLocation.x + x, y: currLocation.y + y)
        let middleEnd = CGPoint(x: prevLocation.x + x, y: prevLocation.y + y)
        drawClaw(start: middleStart, end: middleEnd)
        
        // Left Claw
        x = CGFloat(perp.x)
        y = CGFloat(perp.y)
        let leftStart = CGPoint(x: currLocation.x - x, y: currLocation.y - y)
        let leftEnd = CGPoint(x: prevLocation.x - x, y: prevLocation.y - y)
        drawClaw(start: leftStart, end: leftEnd)
        
        // Right Claw
        let rightStart = CGPoint(x: currLocation.x + x, y: currLocation.y + y)
        let rightEnd = CGPoint(x: prevLocation.x + x, y: prevLocation.y + y)
        drawClaw(start: rightStart, end: rightEnd)
    }
    
    func explodeTouchedSprites(touches: Set<UITouch>) {
        if self.gameStatus == GameState.isPlaying {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            let touchedNodes = nodes(at: location)
            
            touchedNodes.forEach { node in
                if let spriteNode = node as? SKSpriteNode {
                    if let name = spriteNode.name {
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
        if let emitter = SKEmitterNode(fileNamed: "spark") {
            let sound = node.name!.contains("Bomb") ? SKAction.playSoundFileNamed("glass_break.m4a", waitForCompletion: false) : SKAction.playSoundFileNamed("sprite_destroyed.m4a", waitForCompletion: false)
            
            emitter.position = node.position
            emitter.particleColorSequence = nil
            emitter.particleColor = node.color
            self.addChild(emitter)
            
            let wait = SKAction.wait(forDuration: emitter.particleLifetime)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([sound, wait, remove])
            emitter.run(sequence)
        }
        
        // Remove object sprite
        node.removeFromParent()
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
            showLossScreen()
        }
    }
}
