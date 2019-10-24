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
                HStack(alignment: .center) {
                    SettingsButton().frame(width: 33, alignment: .leading)
                    self.title.frame(alignment: .center)
                    self.gameplay.timing.flatMap { TimerView(timing: $0) }
                }
                .padding()
                GeometryReader { proxy in
                    VStack {
                        ZStack(alignment: .top) { BoardView().environmentObject(self.gameplay) }
                            .frame(alignment: .center)
                    }
                    .frame(
                        width: proxy.size.width,
                        height: proxy.size.height,
                        alignment: .center)
                }.edgesIgnoringSafeArea(.all)
                PlayButton(action: self.startNewGame).environmentObject(self.gameplay)
            }
        }
    }
    
    var title: Text {
        Text("Minesweeper 💣")
            .font(Font.system(.headline, design: Font.Design.monospaced))
            .foregroundColor(.primary)
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
        Animation.spring().speed(2)
    }
}


private struct SettingsButton: View {
    var body: some View {
        let image = Image(systemName: "gear")
            .renderingMode(.template)
            .foregroundColor(Color.secondary)
            .imageScale(.medium)
            .padding()
        return NavigationLink(destination: SettingsView()) { image }
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
        let gameplay = Gameplay(x: 30, y: 30)
        gameplay.startGame()
        return gameplay
    }()
    
    static var previews: some View {
        GameView().environmentObject(gameplay)
    }
}
#endif
