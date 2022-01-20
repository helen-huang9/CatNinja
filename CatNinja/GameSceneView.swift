//
//  GameSceneView.swift
//  CatNinja
//
//  Created by Helen Huang on 1/19/22.
//

import SwiftUI
import SpriteKit

struct GameSceneView: View {
    var scene = SKScene(fileNamed: "GameScene")!
    
    var body: some View {
        SpriteView(scene: scene)
    }
}

struct GameSceneView_Previews: PreviewProvider {
    static var previews: some View {
        GameSceneView()
    }
}
