//
//  Tile.swift
//  Minesweeper
//
//  Created by Stas Kochkin on 24/06/2019.
//  Copyright © 2019 appodeal. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

enum TileState: Equatable {
    case unrevealed
    case revealed(Int)
    case marked
    case activated
    case deactivated
}


protocol BoardTile {
    var state: TileState { get }
    var minesAround: Int { get }
    var isMine: Bool { get }
    
    init()
    
    func mark()
    func reveal()
    func mine()
    func incrementMinesAround()
}


final class Tile: BoardTile, ObservableObject, Identifiable {
    internal let id: UUID = UUID()
    
    @Published private(set) var state: TileState = .unrevealed

    private(set) var minesAround = 0, isMine = false
    
    func mine() {
        isMine = true
    }
    
    func incrementMinesAround() {
        minesAround += 1
    }
    
    func mark() {
        if state == .marked {
            state = .unrevealed
        } else if state == .unrevealed {
            state = .marked
        }
    }
    
    func reveal() {
        if state == .marked && isMine {
            state = .deactivated
        } else if isMine {
            state = .activated
        } else if state != .marked {
            state = .revealed(minesAround)
        }
    }
}

extension Tile: Equatable {
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.id == rhs.id
    }
}


extension Tile: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Tile, mines around: \(minesAround), is mine: \(isMine), state: \(state)"
    }
}
