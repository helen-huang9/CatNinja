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
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        ZStack {
                            Image("cat_paw")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 50, alignment: .topLeading)
                                .rotationEffect(Angle(degrees: 180))
                                .foregroundColor(Color.black)
                            Text("Back")
                                .foregroundColor(Color.black)
                                .font(.system(.body, design: .rounded))
                        }
                    })
                    .offset(x: -20, y: 0)
                    .padding(.top, 40)
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
