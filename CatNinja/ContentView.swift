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
                // Background Image
                Image("Home_Background")
                    .resizable()
                    .frame(width: 650, height: 850, alignment: .center)
                    .ignoresSafeArea()
                // New Game Button
                Button(action: {
                    buttonPushed.toggle()
                }, label: {
                    ZStack {
                        Image("orange_cat_button")
                            .scaleEffect(x: 0.25, y: 0.25, anchor: .center)
                            .padding(.bottom, 20.0)
                            .foregroundColor(Color.black)
                        Text("Play")
                            .foregroundColor(Color.black)
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                            .frame(width: 200.0, height: 50.0)
                    }})
                    .fullScreenCover(isPresented: $buttonPushed, onDismiss: {}) {
                        GameSceneView()
                        .ignoresSafeArea(edges: .all)
                    }
                    .transition(.opacity)
            }
        }
        .statusBar(hidden: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
