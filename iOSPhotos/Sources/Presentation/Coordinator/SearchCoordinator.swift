//
//  SearchCoordinator.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

final class SearchCoordinator: SearchCoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType = .search

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let searchViewController = SearchViewController()
        navigationController.viewControllers = [searchViewController]
    }
}

extension SearchCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
