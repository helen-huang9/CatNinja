//
//  GameSceneBeginGame.swift
//  CatNinja
//
//  Created by Helen Huang on 8/5/22.
//

import SpriteKit

extension GameScene {
    
    override func didMove(to view: SKView) {
        self.isUserInteractionEnabled = true
        self.spriteAtlas.preload {}
        deleteAllChildrenAndRespawnUIElements()
        
        // Define buffer frame used for deleting sprites off screen
        self.bufferFrame = CGRect(x: self.view!.frame.origin.x, y: self.view!.frame.origin.y,
                                  width: self.view!.frame.width + 50.0, height: self.view!.frame.height + 50.0)
    }
    
    func deleteAllChildrenAndRespawnUIElements() {
        self.removeAllChildren()
        self.removeAllActions()
        createBackground()
        createScoreLabel()
        createTimerLabel()
        createLivesLabel()
        positionAndAddGameStartCountdownLabel(label: gameStartCountdownLabel)
    }
    
    func playCountdownThenSpawnNodesAndBeginTimer() {
        let block = SKAction.run {
            self.gameStartCountdownLabel.text = "\(self.gameStartCountdownValue)"
            self.gameStartCountdownValue -= 1
        }
        let wait = SKAction.wait(forDuration: 0.5)
        let sequence = SKAction.sequence([block, wait])
        self.run(SKAction.repeat(sequence, count: self.gameStartCountdownValue)) {
            self.gameStartCountdownLabel.removeFromParent()
            self.gameStatus = GameState.isPlaying
            self.beginTimer()
            self.spawnSprites()
        }
    }
}