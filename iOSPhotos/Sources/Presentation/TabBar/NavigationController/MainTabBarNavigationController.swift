//
//  MainTabBarNavigationController.swift
//  iOSPhotos
//
//  Created by Chan on 8/31/24.
//

import UIKit

class MainTabBarNavigationController: UINavigationController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setupNavigationController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNavigationController()
    }
    
    private func setupNavigationController() {
        self.isNavigationBarHidden = true
    }
}
