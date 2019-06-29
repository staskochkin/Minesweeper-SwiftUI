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
    @State var tile: Tile
    var gameplay: Gameplay
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                self.contentBody
                    .font(Font.system(size: geometry.size.height / 2, design: Font.Design.rounded))
                    .shadow(radius: 2.5)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .border(self.borderStyle, cornerRadius: geometry.size.width / 2)
                    .background(self.bacgroundStyle, cornerRadius: geometry.size.width / 2)
                    .gesture(self.tapGesture)
                    .gesture(self.longPressGesture)
                }
        }
    }
}

private extension TileView {
    var bacgroundStyle: some ShapeStyle {
        let gradient: Gradient
        switch tile.state {
        case .unrevealed:           gradient = Gradient(colors: [Color.clear])
        case .revealed(let count):  gradient = revealedBacgroundGradient(count)
        case .activated:            gradient = Gradient(colors: [Color.red.opacity(0.6), Color.red.opacity(0.9)])
        case .deactivated:          gradient = Gradient(colors: [Color.blue.opacity(0.6), Color.green.opacity(0.9)])
        case .marked:               gradient = Gradient(colors: [Color.green.opacity(0.6), Color.purple.opacity(0.9)])
        }
        
        return AngularGradient(gradient: gradient,
                               center: UnitPoint(x: 0, y: 0))
    }
    
    var borderStyle: some ShapeStyle {
        let gradient = tile.isRevealed ?
            Gradient(colors: [Color.clear]) :
            Gradient(colors: [Color.accentColor.opacity(0.6), Color.accentColor.opacity(0.9)])
        
        return AngularGradient(gradient: gradient,
                               center: UnitPoint(x: 0, y: 0))
    }
    
    func reveal() {
        gameplay.reveal(tile)
    }
    
    func mark() {
        gameplay.mark(tile)
    }
    
    var tapGesture: some Gesture {
        TapGesture()
            .onEnded(self.reveal)
    }
    
    var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: 0.2, maximumDistance: 5)
            .onEnded { _ in self.mark() }
    }
    
    var contentBody: some View {
        switch tile.state {
        case .unrevealed:           return unrevealedView
        case .revealed(let count):  return revealedView(count)
        case .activated:            return activatedView
        case .deactivated:          return deactivatedView
        case .marked:               return markedView
        }
    }
    
    func revealedView(_ count: Int) -> Text {
        let text = count > 0 ? "\(count)" : " "
        return Text(text).color(Color.white)
    }
    
    func revealedBacgroundGradient(_ count: Int) -> Gradient {
        switch count {
        case 1: return Gradient(colors: [Color.yellow.opacity(0.3), Color.yellow.opacity(0.6)])
        case 2: return Gradient(colors: [Color.yellow.opacity(0.6), Color.orange.opacity(0.9)])
        case 3: return Gradient(colors: [Color.yellow.opacity(0.9), Color.orange.opacity(0.6)])
        case 4: return Gradient(colors: [Color.orange.opacity(0.6), Color.orange.opacity(0.9)])
        case 5: return Gradient(colors: [Color.orange.opacity(0.9), Color.red.opacity(0.6)])
        default: return Gradient(colors: [Color.clear])
        }
    }
    
    var unrevealedView: Text { Text(" ") }
    var activatedView: Text { Text("💣") }
    var deactivatedView: Text { Text("🎖") }
    var markedView: Text { Text("🙈") }
}


