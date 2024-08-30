//
//  SceneDelegate.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var tabBarCoordinator: Coordinator?
    var coverViewManager: CoverViewManager?
    var navigationController: UINavigationController?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        SizeManager.shared.updateSizes()
        coverViewManager = CoverViewManager(window: window)
        
        navigationController = UINavigationController()
        navigationController?.isNavigationBarHidden = true
        tabBarCoordinator = TabBarCoordinator(navigationController: navigationController!)
        tabBarCoordinator?.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        coverViewManager?.addCoverView()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        coverViewManager?.addCoverView()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        coverViewManager?.removeCoverView()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        coverViewManager?.removeCoverView()
    }
    
}

