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
    private lazy var gameplay: Gameplay = {
        Gameplay(x: 8, y: 8)
    }()
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: scene)
        window.rootViewController = UIHostingController(rootView: GameView().environmentObject(gameplay))
        self.window = window
        window.makeKeyAndVisible()
    }
}

