//
//  ContentView.swift
//  CatNinja
//
//  Created by Helen Huang on 1/19/22.
//

import SwiftUI

struct ContentView: View {    
    var body: some View {
        NavigationView {
            ZStack {
                Color.pink
                    .ignoresSafeArea()
                Image("orange_cat_button")
                    .scaleEffect(x: 0.25, y: 0.25, anchor: .center)
                    .padding(.bottom, 20.0)
                    .foregroundColor(Color.black)
                NavigationLink(destination: { GameSceneView() })
                {
                    Text("New Game")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                        .font(.title)
                        .frame(width: 200.0, height: 50.0)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
