//
//  SceneDelegate.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 13.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        
       let window = UIWindow(windowScene: windowsScene)
        self.window = window
        let initialNavigationController = UINavigationController()
        window.rootViewController = initialNavigationController
        window.makeKeyAndVisible()
        
        let _ = StartRouter(navigationController: initialNavigationController,window: window)
        
    }
}

