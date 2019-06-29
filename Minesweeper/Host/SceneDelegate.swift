//
//  SceneDelegate.swift
//  Minesweeper
//
//  Created by Stas Kochkin on 24/06/2019.
//  Copyright © 2019 appodeal. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let gameplay = Gameplay(x: 8, y: 8)
        window.rootViewController = UIHostingController(rootView: GameView().environmentObject(gameplay))
        self.window = window
        window.makeKeyAndVisible()
    }
}

