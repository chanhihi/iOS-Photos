//
//  MainTabBarController.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.selectedIndex = AppStateManager.shared.loadLastTabIndex()
    }

    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        AppStateManager.shared.saveLastTabIndex(tabBarController.selectedIndex)
    }
}
