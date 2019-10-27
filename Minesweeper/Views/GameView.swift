//
//  ContentView.swift
//  Minesweeper
//
//  Created by Stas Kochkin on 24/06/2019.
//  Copyright © 2019 appodeal. All rights reserved.
//

import SwiftUI

struct GameView : View {
    @EnvironmentObject var gameplay: Gameplay
    
    var body: some View {
        NavigationView {
            VStack {
                if gameplay.isStarted {
                    Spacer()
                    gameplay.timing.map(TimerView.init)
                    GeometryReader { proxy in
                        self.boardView
                            .frame(
                                width: proxy.boardSize,
                                height:  proxy.boardSize,
                                alignment: .center
                            )
                    }
                    .transition(self.transition)
                    .animation(self.animation)
                }
                
                PlayButton(action: self.startNewGame)
                    .environmentObject(self.gameplay)
            }
            .transition(transition)
            .navigationBarTitle("Minesweeper", displayMode: .inline)
            .navigationBarItems(trailing: SettingsButton())
            .font(Font.system(.headline, design: Font.Design.monospaced))
            .foregroundColor(.primary)
        }
    }
    
    func startNewGame() {
        gameplay.startGame()
    }
    
    private var boardView: some View {
        return BoardView()
            .environmentObject(self.gameplay)
    }
    
    private var transition: AnyTransition {
        let insertion = AnyTransition
            .move(edge: .top)
            .combined(with: .opacity)
        let removal = AnyTransition
            .move(edge: .bottom)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    private var animation: Animation {
        Animation.spring().speed(2)
    }
}

private extension GeometryProxy {
    var boardSize: CGFloat {
        return min(size.width, size.height) - 16
    }
}

private struct SettingsButton: View {
    @State private var isShown: Bool = false
    var body: some View {
        return Button(action: {
            self.isShown.toggle()
        }) {
            Image(systemName: "gear")
                .renderingMode(.template)
                .foregroundColor(Color.secondary)
                .imageScale(.medium)
        }
        .sheet(isPresented: self.$isShown) { SettingsView() }
    }
    
    var animation: Animation {
        Animation
            .spring()
            .speed(2)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static let gameplay: Gameplay = {
        let gameplay = Gameplay(x: 3, y: 3)
        gameplay.startGame()
        return gameplay
    }()
    
    static var previews: some View {
        GameView().environmentObject(gameplay)
    }
}
#endif
