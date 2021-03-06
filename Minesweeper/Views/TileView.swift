//
//  TileView.swift
//  Minesweeper
//
//  Created by Stas Kochkin on 24/06/2019.
//  Copyright © 2019 appodeal. All rights reserved.
//

import Foundation
import SwiftUI


struct TileView: View {
    private struct Constants {
        static func font(_ height: CGFloat) -> Font {
            return Font.system(
                size: height,
                design: Font.Design.rounded
            )
        }
        
        static var unrevealedView: Text { Text("?").foregroundColor(Color.white) }
        static var activatedView: Text { Text("💣") }
        static var deactivatedView: Text { Text("🎖") }
        static var markedView: Text { Text("🙈") }
        
        static func revealedView(_ count: Int) -> Text {
            let text = count > 0 ? "\(count)" : " "
            return Text(text).foregroundColor(Color.white)
        }
    }
    
    @ObservedObject var tile: Tile
    @GestureState var isLongPressed = false
    
    let gameplay: Gameplay
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                GeometryReader { groupGeometry in
                    self.contentBody
                        .font(Constants.font(groupGeometry.size.height / 3 * 2))
                        .shadow(radius: 5)
                        .frame(
                            width: groupGeometry.size.height,
                            height: groupGeometry.size.width,
                            alignment: .center
                        )
                }
            }
            .saturation(1.5)
            .background(self.backgroundStyle)
            .cornerRadius(CGFloat.greatestFiniteMagnitude)
            .shadow(radius: 5)
            .scaleEffect(self.isLongPressed ? 1.3 : 1)
            .frame(
                width: geometry.size.height * 0.95,
                height: geometry.size.width * 0.95,
                alignment: .center
            )
            .gesture(self.tapGesture)
            .simultaneousGesture(self.longPressGesture)
            .animation(.spring())
        }
        .transition(AnyTransition.tile)
        .animation(Animation.tile)
    }
    
    func reveal() {
        withAnimation {
            gameplay.reveal(tile.self)
        }
    }
    
    func mark() {
        withAnimation {
            gameplay.mark(tile.self)
        }
    }
}


private extension TileView {
    var backgroundStyle: some View {
        let gradient: Gradient
        switch tile.state {
        case .revealed(let count): gradient = revealedBacgroundGradient(count)
        case .unrevealed: gradient = Gradient(colors: [
            Color.accentColor.opacity(0.6),
            Color.accentColor.opacity(0.9)])
        case .activated: gradient = Gradient(colors: [
            Color.red.opacity(0.6),
            Color.red.opacity(0.9)
        ])
        case .deactivated: gradient = Gradient(colors: [
            Color.blue.opacity(0.6),
            Color.green.opacity(0.9)
        ])
        case .marked: gradient = Gradient(colors: [
            Color.green.opacity(0.6),
            Color.purple.opacity(0.9)
        ])
        }
        
        return AngularGradient(gradient: gradient,
                               center: UnitPoint(x: 0, y: 0))
    }
    
    var borderStyle: some ShapeStyle {
        let gradient = Gradient(colors: [
            Color.accentColor.opacity(0.6),
            Color.accentColor.opacity(0.9)
        ])
        return AngularGradient(
            gradient: gradient,
            center: UnitPoint(x: 0, y: 0)
        )
    }
    
    var tapGesture: some Gesture {
        TapGesture()
            .onEnded(self.reveal)
    }
    
    var longPressGesture: some Gesture {
        LongPressGesture(
            minimumDuration: 0.2,
            maximumDistance: 5
        )
            .onEnded { _ in self.mark() }
            .updating($isLongPressed) { value, state, transcation in state = value }
    }
    
    var contentBody: some View {
        let view: Text
        switch tile.state {
        case .unrevealed:           view = Constants.unrevealedView
        case .revealed(let count):  view = Constants.revealedView(count)
        case .activated:            view = Constants.activatedView
        case .deactivated:          view = Constants.deactivatedView
        case .marked:               view = Constants.markedView
        }
        return view
    }
    
    func revealedBacgroundGradient(_ count: Int) -> Gradient {
        guard count > 0 else { return Gradient(colors: [Color.clear]) }
        let colors: [Color] = [
            Color.yellow.opacity(0.5),
            Color.yellow.opacity(0.85),
            Color.orange.opacity(0.5),
            Color.orange.opacity(0.85),
            Color.red.opacity(0.5),
            Color.red.opacity(0.85)
        ]
        return Gradient(colors: [
            colors[count - 1],
            colors[min(colors.count - 1, count + 1)]
        ])
    }
}

private extension AnyTransition {
    static var tile: AnyTransition {
        let insertion = AnyTransition
            .scale(scale: 1.3)
            .combined(with: .opacity)
        let removal = AnyTransition
            .scale(scale: 0.6)
            .combined(with: .opacity)
        return .asymmetric(
            insertion: insertion,
            removal: removal
        )
    }
}

private extension Animation {
    static var tile: Animation {
        return Animation
            .easeIn
            .delay(Double.random(in: 0.1...0.5))
    }
}

#if DEBUG
struct TitleView_Previews : PreviewProvider {
    static let gameplay = Gameplay(x: 1, y: 1)
    static let markedTile: Tile = {
        var tile = Tile()
        tile.mark()
        return tile
    }()
    
    static let mineTile: Tile = {
        var tile = Tile()
        tile.mine()
        tile.reveal()
        return tile
    }()
    
    static let unrevealedTile: Tile = {
        var tile = Tile()
        tile.incrementMinesAround()
        return tile
    }()
    
    static let revealedTile: Tile = {
        var tile = Tile()
        tile.incrementMinesAround()
        tile.incrementMinesAround()
        tile.reveal()
        return tile
    }()
    
    static var previews: some View {
        Group {
            TileView(tile: markedTile, gameplay: gameplay)
            TileView(tile: mineTile, gameplay: gameplay)
            TileView(tile: unrevealedTile, gameplay: gameplay)
            TileView(tile: revealedTile, gameplay: gameplay)
        }
        .previewLayout(.fixed(width: 200, height: 200))
    }
}
#endif

