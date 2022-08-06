//
//  GameSceneEndScreen.swift
//  CatNinja
//
//  Created by Helen Huang on 8/5/22.
//

import SpriteKit

extension GameScene {
    
    func showLossScreen() {
        self.isShowingLossScreen = true
        self.livesValue = max(self.livesValue, 0)
        self.livesLabel.text = "x\(self.livesValue)"
        self.run(SKAction.playSoundFileNamed("game_over.wav", waitForCompletion: false))
        createLossLabel()
        createFinalScoreLabel()
    }
    
    func restartGame() {
        self.scoreValue = 0
        self.livesValue = 3
        self.timerValue = 60
        self.gameStartCountdownValue = 3
        self.gameStartTime = Date.now
        deleteAllChildrenAndRespawnUIElements()
        
        self.gameStatus = GameState.start
        self.isShowingLossScreen = false
        if let view = self.view { view.isPaused = false }
    }
}
