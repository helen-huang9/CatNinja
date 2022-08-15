//
//  GameSceneBeginGame.swift
//  CatNinja
//
//  Created by Helen Huang on 8/5/22.
//

import SpriteKit

extension GameScene {
    /// Called when the GameScene moves into view. Reloads the GameScene and begins the game.
    /// - Parameter view: The parent view, which in this case is SpriteView().
    override func didMove(to view: SKView) {
        // Define buffer frame used for deleting sprites off screen
        self.bufferFrame = CGRect(x: self.view!.frame.origin.x, y: self.view!.frame.origin.y,
                                  width: self.view!.frame.width + 50.0, height: self.view!.frame.height + 50.0)
        self.isUserInteractionEnabled = true
        self.spriteAtlas.preload {}
        deleteAllChildrenAndRespawnUIElements()
        self.beginGameCountDown()
    }
    
    /// Deletes all of GameScene's children and actions, and respawns the UI elements, including the
    /// background, score, lives, and timer.
    func deleteAllChildrenAndRespawnUIElements() {
        self.removeAllChildren()
        self.removeAllActions()
        createBackground()
        createScoreLabel()
        createHighScoreLabel()
        createTimerLabel()
        createLivesLabel()
        createGameStartCountdownLabel()
    }
    
    /// Creates and runs an SKAction that counts down to the start of the game.
    func beginGameCountDown() {
        self.gameStatus = GameState.countdown
        let block = SKAction.run {
            self.gameStartCountdownLabel.text = "\(self.gameStartCountdownValue)"
            self.gameStartCountdownValue -= 1
        }
        let wait = SKAction.wait(forDuration: 0.5)
        let sequence = SKAction.sequence([block, wait])
        self.run(SKAction.repeat(sequence, count: self.gameStartCountdownValue)) {
            self.gameStartCountdownLabel.removeFromParent()
            self.beginGame()
        }
    }
    
    /// Begins the game. Starts the game timer and spawns and deletes sprites.
    func beginGame() {
        self.gameStatus = GameState.isPlaying
        self.beginTimer()
        self.continuouslySpawnSprites()
        self.continuouslyDeleteSpritesOutOfFrame()
    }
}
