//
//  BoardView.swift
//  Minesweeper
//
//  Created by Stas Kochkin on 24/06/2019.
//  Copyright © 2019 appodeal. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

extension IndexedTile: Identifiable {
    typealias ID = UUID
}

struct BoardView: View {
    typealias TileType = IndexedTile<Tile>
    
    @EnvironmentObject var gameplay: Gameplay
    
    private let offset: CGFloat = 8
    
    var body: some View {
        ZStack(alignment: .center) {
            ForEach(self.gameplay.board.tiles.identified(by: \.id)) { tile in
                self.view(for: tile, board: self.gameplay.board)
                .frame(width: 320, height: 400, alignment: .center).clipped()
            }
        }
    }
    
    private func preferredSize(tiles: Index, size: CGSize) -> CGFloat {
        let boardWidth: CGFloat = CGFloat(gameplay.board.size.x)
        let boardHeight: CGFloat = CGFloat(gameplay.board.size.y)
        let width: CGFloat = (size.width - (boardWidth + 1) * offset) / boardWidth
        let height: CGFloat = (size.height - (boardHeight + 1) * offset) / boardHeight
        return min(width, height)
    }
    
    private func view(for tile:TileType,
                      board: Board<Tile> ,
                      size: CGSize = CGSize(width: 320, height: 500)) -> some View {
        let tileSize: CGFloat = preferredSize(tiles: board.size, size: size)
        
        let x: CGFloat = CGFloat(tile.index.x) * (tileSize + offset) + tileSize / 2 + offset
        let y: CGFloat = CGFloat(tile.index.y) * (tileSize + offset) + tileSize / 2 + offset
        
        return TileView(tile: tile.value, gameplay: gameplay)
            .frame(width: tileSize, height: tileSize, alignment: .center)
            .position(x: x, y: y)
    }
}
