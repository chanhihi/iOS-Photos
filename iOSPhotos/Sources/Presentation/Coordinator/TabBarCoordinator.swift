//
//  TabBarCoordinator.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

final class TabBarCoordinator: TabBarCoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var tabBarController: MainTabBarController
    private let coordinatorFactory: CoordinatorFactory
    var type: CoordinatorType = .tabbar
    
    init(navigationController: UINavigationController, coordinatorFactory: CoordinatorFactory = CoordinatorFactory()) {
        self.navigationController = navigationController
        self.tabBarController = MainTabBarController()
        self.coordinatorFactory = coordinatorFactory
    }
    
    func start() {
        let tabs = TabBarItemType.allCases.map { itemType -> UIViewController in
            let navigationController = coordinatorFactory.createNavigationController(for: itemType)
            navigationController.tabBarItem = UITabBarItem(title: itemType.title,
                                                           image: UIImage(systemName: itemType.iconName),
                                                           selectedImage: UIImage(systemName: itemType.iconName + ".fill"))
            
            let coordinator = coordinatorFactory.createCoordinator(for: itemType, using: navigationController)
            coordinator.start()
            
            childCoordinators.append(coordinator)
            
            return navigationController
        }
        
        tabBarController.viewControllers = tabs
        tabBarController.selectedIndex = AppStateManager.shared.loadLastTabIndex()
        
        navigationController.setViewControllers([tabBarController], animated: false)
    }
}

extension TabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
