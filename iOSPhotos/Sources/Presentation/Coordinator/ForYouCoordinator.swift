//
//  ForYouCoordinator.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

class ForYouCoordinator: Coordinator {
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let forYouViewController = ForYouViewController()
        navigationController?.viewControllers = [forYouViewController]
    }
}
