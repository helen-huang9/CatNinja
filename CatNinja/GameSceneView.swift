//
//  GameSceneView.swift
//  CatNinja
//
//  Created by Helen Huang on 1/19/22.
//

import SwiftUI
import SpriteKit

struct GameSceneView: View {
    @Environment(\.dismiss) private var dismiss
    let scene = GameScene(fileNamed: "GameScene")!
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Button("Back to Title Screen") {
                        dismiss()
                    }
                    .padding(.top, 40)
                    .padding(.leading, 20)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct GameSceneView_Previews: PreviewProvider {
    static var previews: some View {
        GameSceneView()
    }
}
