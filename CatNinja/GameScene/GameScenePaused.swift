//
//  GameScenePaused.swift
//  CatNinja
//
//  Created by Helen Huang on 8/6/22.
//

extension GameScene {
    
    func pauseGamePlay() {
        self.gameStatus = GameState.isPaused
        if let view = self.view { view.isPaused = true }
    }
    
    func resumeGamePlay() {
        self.gameStatus = GameState.isPlaying
        if let view = self.view {
            view.isPaused = false
        }
    }
}
