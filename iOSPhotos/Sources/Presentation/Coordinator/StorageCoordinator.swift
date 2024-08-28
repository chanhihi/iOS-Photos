//
//  StorageCoordinator.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

class StorageCoordinator: Coordinator {
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func start() {
        let storageViewController = StorageViewController()
        navigationController?.viewControllers = [storageViewController]
    }
}
