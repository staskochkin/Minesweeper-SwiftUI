//
//  PlayButton.swift
//  Minesweeper
//
//  Created by Stas Kochkin on 24.10.2019.
//  Copyright © 2019 appodeal. All rights reserved.
//

import SwiftUI

struct PlayButton: View {
    typealias ViewProps = (text: Text, gradient: Gradient)
    
    @EnvironmentObject var gameplay: Gameplay
    var action: () -> ()
    var state: GameState { return gameplay.state }
    
    var body: some View {
        let props: ViewProps
        switch state {
        case .idle: props = idle()
        case .started: props = started()
        case .completed(let isWin):props = completed(isWin)
        }
        
        let background = LinearGradient(
            gradient: props.gradient,
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 1, y: 0.5)
        )
        
        return Button(action: withAnimation { action }) {
            props.text.frame(
                width: 320,
                height: 33,
                alignment: .center
            )}
            .background(background)
            .cornerRadius(16)
            .transition(transition)
    }
    
    private var transition: AnyTransition {
        let insertion = AnyTransition
            .scale(scale: 1.2)
            .combined(with: .opacity)
            .animation(animation)
        let removal = AnyTransition
            .scale(scale: 0.8)
            .combined(with: .opacity)
            .animation(animation)
        return .asymmetric(
            insertion: insertion,
            removal: removal
        )
    }
    
    private var animation: Animation {
        Animation
            .easeInOut
            .speed(2)
            .delay(0.1)
    }
    
    private func idle() -> ViewProps {
        return (
            Text("New Game")
                .font(Font.system(.callout))
                .foregroundColor(.white),
            Gradient(colors: [
                Color.blue.opacity(0.6),
                Color.blue.opacity(0.9)
            ])
        )
    }
    
    private func started() -> ViewProps {
        return (
            Text("Skip")
                .font(Font.system(size: 12, design: .rounded))
                .foregroundColor(.gray),
            Gradient(colors: [
                Color.gray.opacity(0.3),
                Color.black.opacity(0.2)
            ])
        )
    }
    
    private func completed(_ isWin: Bool) -> ViewProps {
        return (
            Text(isWin ? "Your Win!. Start new game?" : "Your Lose. Try again?")
                .font(Font.system(size: 12, design: .monospaced))
                .foregroundColor(.primary),
            isWin ?
                Gradient(colors: [Color.yellow.opacity(0.8), Color.orange.opacity(0.8)]) :
                Gradient(colors: [Color.purple.opacity(0.3), Color.red.opacity(0.5)])
        )
    }
}

#if DEBUG
struct PlayButton_Previews : PreviewProvider {
    static let idleGameplay: Gameplay = {
        return Gameplay(x: 1, y: 1)
    }()
    
    static let startedGameplay: Gameplay = {
        let gameplay = Gameplay(x: 1, y: 1)
        gameplay.startGame()
        return gameplay
    }()
    
    static var previews: some View {
        Group {
            PlayButton(action: {}).environmentObject(idleGameplay)
            PlayButton(action: {}).environmentObject(startedGameplay)
        }.previewLayout(.fixed(width: 350, height: 50))
        
    }
}
#endif
