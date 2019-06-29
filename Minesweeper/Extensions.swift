//
//  Extensions.swift
//  Minesweeper
//
//  Created by Stas Kochkin on 25/06/2019.
//  Copyright © 2019 appodeal. All rights reserved.
//

import Foundation


extension Array {
    mutating func forEach(body: (inout Element) throws -> Void) rethrows {
        for index in indices {
            try body(&self[index])
        }
    }
}

func bind<T,U>(_ x: T, _ closure:(T) -> U) -> U {
    closure(x)
}
