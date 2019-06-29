//
//  GameBoard.swift
//  Minesweeper
//
//  Created by Stas Kochkin on 24/06/2019.
//  Copyright © 2019 appodeal. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


enum GameState {
    case idle
    case started
    case completed(Bool)
}

extension BoardTile {
    var isRevealed: Bool {
        switch state {
        case .revealed: return true
        case .marked: return isMine
        default: return false
        }
    }
}


final class Gameplay: BindableObject {
    typealias BoardType = Board<Tile>
    
    let didChange = PassthroughSubject<GameState, Never>()
    
    private(set) var board: BoardType
    
    private(set) var state: GameState = .idle {
        didSet { didChange.send(state) }
    }
    
    init(x: Int, y: Int) {
        board = BoardType(x: x, y: y)
    }
    
    func reveal(_ tile: BoardTile) {
        switch state {
        case .started: _reveal(tile: tile)
        case .idle: startGame(tile)
        case .completed: break
        }
    }
    
    func mark(_ tile: BoardTile) {
        switch state {
        case .started: _mark(tile: tile)
        default: break
        }
    }
    
    func startGame(_ tile: BoardTile? = nil) {
        defer { state = .started }
        board.arrange()
        board.startGame(tile as? Tile)
        guard  let tile = tile else { return }
        _reveal(tile: tile)
    }
    
    private func _reveal(tile: BoardTile, force: Bool = true) {
        guard tile.state != .marked, force || tile.state != .activated else { return }
        
        tile.reveal()
        
        if tile.state == .activated {
            board.endGame()
            state = .completed(false)
        } else if board.isWin {
            board.endGame()
            state = .completed(true)
        } else if tile.minesAround == 0 {
            board
                .indexed(tile: tile as? Tile)
                .map(board.neighbors)?.filter { !$0.value.isRevealed && !$0.value.isMine }
                .forEach { _reveal(tile: $0.value, force: false) }
        }
    }
    
    private func _mark(tile: BoardTile) {
        tile.mark()
        guard board.isWin else { return }
        board.endGame()
        state = .completed(true)
    }
}
