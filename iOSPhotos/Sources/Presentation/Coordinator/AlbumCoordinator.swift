//
//  AlbumCoordinator.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

class AlbumCoordinator: AlbumCoordinatorProtocol {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .album

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let albumViewController = AlbumViewController()
        navigationController.viewControllers = [albumViewController]
    }
}

extension AlbumCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
