//
//  GameSceneEndScreen.swift
//  CatNinja
//
//  Created by Helen Huang on 8/5/22.
//

import SpriteKit

extension GameScene {
    /// Shows the End screen of the game scene.
    func showEndScreen() {
        self.livesValue = max(self.livesValue, 0)
        self.livesLabel.text = "x\(self.livesValue)"
        self.run(SKAction.playSoundFileNamed("game_over.wav", waitForCompletion: false))
        createLossLabel()
        createFinalScoreLabel()
        updateHighScore()
    }
    
    /// Updates the high score if the user beat their high score.
    func updateHighScore() {
        let userDefaults = UserDefaults.standard
        let oldHighScore = userDefaults.integer(forKey: "high_score")
        if self.scoreValue > oldHighScore {
            userDefaults.set(self.scoreValue, forKey: "high_score")
        }
    }
    
    /// Restarts the game from the beginning.
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
