//
//  GameSceneView.swift
//  CatNinja
//
//  Created by Helen Huang on 1/19/22.
//

import SwiftUI
import SpriteKit

struct GameSceneView: View {
    let scene = SKScene(size: CGSize(width: 50, height: 50))
    var body: some View {
        SpriteView(scene: scene)
            .background(Color.red)
    }
}

struct GameSceneView_Previews: PreviewProvider {
    static var previews: some View {
        GameSceneView()
    }
}
