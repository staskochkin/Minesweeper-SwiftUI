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
    
    private func layoutTraits(_ proxy: GeometryProxy) -> LayoutTraits {
        LayoutTraits(offset: CGSize(width: 0, height: proxy.safeAreaInsets.top - 200),
                     alignment: .top)
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                bind(self.layoutTraits(proxy)) { traits in
                    VStack {
                        Header(traits: traits)
                        ZStack(alignment: .top) { BoardView().environmentObject(self.gameplay) }
                            .animation(self.animation)
                            .frame(alignment: .center)
                        self.button
                        }.frame(width: proxy.size.width,
                                height: proxy.size.height,
                                alignment: .center)
                }
                }.edgesIgnoringSafeArea(.all)
        }
    }
    
    
    var button: some View {
        let text: Text
        let gradient: Gradient
        switch gameplay.state {
        case .idle:
            text = Text("New Game")
                .font(Font.system(.callout))
                .color(.white)
            gradient = Gradient(colors: [Color.blue.opacity(0.6), Color.blue.opacity(0.9)])
        case .started:
            text = Text("Skip")
            .font(Font.system(size: 12, design: .rounded))
            .color(.accentColor)
        gradient = Gradient(colors: [Color.white.opacity(0.1), Color.black.opacity(0.1)])
        case .completed(let isWin):
            text = Text(isWin ? "Your Win!. Start new game?" : "Your Lose. Try again?")
                .font(Font.system(size: 12, design: .monospaced))
                .color(.primary)
            gradient = isWin ?
                Gradient(colors: [Color.yellow.opacity(0.8), Color.orange.opacity(0.8)]) :
                Gradient(colors: [Color.purple.opacity(0.3), Color.red.opacity(0.5)])
        }
        
        let bacground = LinearGradient(gradient: gradient, startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
        return Button(action: self.startNewGame) { text.frame(width: 320, height: 33, alignment: .center) }
            .background(bacground, cornerRadius: 16)
    }
    
    func startNewGame() {
        withAnimation {
            gameplay.startGame()
        }
    }
    
    var transition: AnyTransition {
        let insertion = AnyTransition
            .move(edge: .top)
            .combined(with: .opacity)
        let removal = AnyTransition
            .move(edge: .bottom)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    var animation: Animation {
        Animation.spring(initialVelocity: 5)
            .speed(2)
            .delay(0.03 * Double.random(in: 0...30))
    }
}


private struct Header: View {
    var traits: LayoutTraits
    
    var body: some View {
        Text("Minesweeper 💣")
            .font(Font.system(.headline, design: Font.Design.monospaced))
            .color(.primary)
            .offset(traits.offset)
    }
}

private struct LayoutTraits {
    let offset: CGSize
    let alignment: Alignment
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
#endif
