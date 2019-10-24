//
//  Board.swift
//  Minesweeper
//
//  Created by Stas Kochkin on 24/06/2019.
//  Copyright © 2019 appodeal. All rights reserved.
//

import Foundation
import SwiftUI

typealias Index = (x: Int, y: Int)

struct IndexedTile <T> where T: BoardTile, T: Equatable {
    let id: UUID = UUID()
    let index: Index
    let value: T
    
    init(index: Index, value: T) {
        self.value = value
        self.index = index
    }
}

extension IndexedTile: Identifiable, Equatable {
    typealias ID = UUID
    
    static func == (lhs: IndexedTile<T>, rhs: IndexedTile<T>) -> Bool {
        return lhs.value == rhs.value
    }
}


final class Board<T> where T: BoardTile, T: Equatable {
    typealias IndexedTileType = IndexedTile<T>
    
    private(set) var tiles:[IndexedTileType] = []
    let size: Index
    
    var isWin: Bool { tiles.reduce(true) { $0 && $1.value.isRevealed } }
    
    init(x: Int, y: Int) {
        size = (x, y)
    }
    
    subscript(index: Index) -> IndexedTileType? {
        guard index.x >= 0, index.y >= 0, index.x < size.x, index.y < size.y else { return nil }
        return tiles[index.y * size.x + index.x]
    }
    
    func indexed(tile: T?) -> IndexedTileType? {
        return  tile.flatMap { tile in tiles.first { $0.value == tile } }
    }
    
    func arrange() {
        tiles.removeAll()
        (0..<size.y).forEach { y in
            (0..<size.x).forEach { x in
                let tile = IndexedTile<T>(index: (x, y), value: T())
                tiles.append(tile)
            }
        }
    }
    
    func startGame(_ targetTile: T?) {
        var protectedTiles:[IndexedTileType] = []
        if let targetTile = indexed(tile: targetTile) {
            protectedTiles.append(contentsOf: neighbors(of: targetTile))
            protectedTiles.append(targetTile)
        }
        
        let maxMinesCount: Int = ((size.x * size.y) / 7)
        var posibleMines: [IndexedTileType] = tiles.filter { !protectedTiles.contains($0) }
        
        (0..<maxMinesCount)
            .forEach { _ in
                let index = Int.random(in: 0..<posibleMines.count)
                posibleMines[index].value.mine()
                var neighbourhood = neighbors(of: posibleMines[index])
                neighbourhood.forEach { $0.value.incrementMinesAround() }
                posibleMines.remove(at: index)
        }
    }
    
    func neighbors(of targetTile: IndexedTileType) -> [IndexedTileType] {
        let dx:[Int] = [-1,  0,  1, -1, 1, -1, 0, 1]
        let dy:[Int] = [-1, -1, -1,  0, 0,  1, 1, 1]
        return dx
            .enumerated()
            .compactMap {
                let index: Index = (targetTile.index.x + $0.element,
                                    targetTile.index.y + dy[$0.offset])
                return self[index]
        }
    }
    
    func endGame() {
        tiles.forEach { $0.value.reveal() }
    }
}

extension Board: CustomDebugStringConvertible {
    var debugDescription: String { "" }
}
