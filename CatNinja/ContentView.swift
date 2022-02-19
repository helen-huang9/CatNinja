//
//  ContentView.swift
//  CatNinja
//
//  Created by Helen Huang on 1/19/22.
//

import SwiftUI

struct ContentView: View {
    @State private var buttonPushed = false
    var body: some View {
        NavigationView {
            ZStack {
                Color.pink
                    .ignoresSafeArea()
                Button(action: {
                    buttonPushed.toggle()
                }, label: {
                    ZStack {
                        Image("orange_cat_button")
                            .scaleEffect(x: 0.25, y: 0.25, anchor: .center)
                            .padding(.bottom, 20.0)
                            .foregroundColor(Color.black)
                        Text("New Game")
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                            .font(.title)
                            .frame(width: 200.0, height: 50.0)
                    }})
                    .fullScreenCover(isPresented: $buttonPushed, onDismiss: didDismiss) {
                        GameSceneView()
                        .ignoresSafeArea(edges: .all)
                    }
            }
        }
    }
    
    func didDismiss() {
        buttonPushed.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
