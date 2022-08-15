//
//  GameScenePaused.swift
//  CatNinja
//
//  Created by Helen Huang on 8/6/22.
//

extension GameScene {
    /// Pauses all SKActions in the scene.
    func pauseGamePlay() {
        self.gameStatus = GameState.isPaused
        if let view = self.view { view.isPaused = true }
    }
    
    /// Resumes all the SKActions in the scene.
    func resumeGamePlay() {
        self.gameStatus = GameState.isPlaying
        if let view = self.view {
            view.isPaused = false
        }
    }
}
