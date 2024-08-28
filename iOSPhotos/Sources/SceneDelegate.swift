//
//  SceneDelegate.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let tabBarCoordinator = TabBarCoordinator(navigationController: nil)

        tabBarCoordinator.start()
        window.rootViewController = tabBarCoordinator.tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
    
}

