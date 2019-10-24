//
//  Timing.swift
//  Minesweeper
//
//  Created by Stas Kochkin on 30/06/2019.
//  Copyright © 2019 appodeal. All rights reserved.
//

import Foundation
import Combine
import SwiftUI


final class Timing: ObservableObject {
    @Published private(set) var playingTime: TimeInterval = 0
    
    private var timer: Timer?
    
    func start() {
        playingTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1,
                                     repeats: true) { [weak self] _ in self?.playingTime += 1 }
        timer?.fire()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
