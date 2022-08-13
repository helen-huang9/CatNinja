//
//  GameSceneEndScreen.swift
//  CatNinja
//
//  Created by Helen Huang on 8/5/22.
//

import SpriteKit

extension GameScene {
    
    func showEndScreen() {
        self.livesValue = max(self.livesValue, 0)
        self.livesLabel.text = "x\(self.livesValue)"
        self.run(SKAction.playSoundFileNamed("game_over.wav", waitForCompletion: false))
        createLossLabel()
        createFinalScoreLabel()
        updateHighScore()
    }
    
    func updateHighScore() {
        let userDefaults = UserDefaults.standard
        let oldHighScore = userDefaults.integer(forKey: "high_score")
        if self.scoreValue > oldHighScore {
            userDefaults.set(self.scoreValue, forKey: "high_score")
        }
    }
    
    func restartGame() {
        self.scoreValue = 0
        self.livesValue = 3
        self.timerValue = 60
        self.gameStartCountdownValue = 3
        self.gameStartTime = Date.now
        deleteAllChildrenAndRespawnUIElements()
        
        if let view = self.view { view.isPaused = false }
        self.beginGameCountDown()
    }
}
