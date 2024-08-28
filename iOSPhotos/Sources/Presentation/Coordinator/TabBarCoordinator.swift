//
//  TabBarCoordinator.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

class TabBarCoordinator: Coordinator {
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    var tabBarController: MainTabBarController
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.tabBarController = MainTabBarController()
    }
    
    func start() {
        let tabs = TabBarItemType.allCases.map { itemType -> UIViewController in
            let navigationController = UINavigationController()
            navigationController.tabBarItem = UITabBarItem(title: itemType.title,
                                                           image: UIImage(systemName: itemType.iconName),
                                                           selectedImage: UIImage(systemName: itemType.iconName + ".fill"))
            
            let coordinator = createCoordinator(for: itemType, using: navigationController)
            coordinator.start()
            return navigationController
        }
        
        tabBarController.viewControllers = tabs
        tabBarController.selectedIndex = AppStateManager.shared.loadLastTabIndex()
    }
    
    private func createCoordinator(for type: TabBarItemType, using navigationController: UINavigationController) -> Coordinator {
        switch type {
        case .storage:
            return StorageCoordinator(navigationController: navigationController)
        case .foryou:
            return ForYouCoordinator(navigationController: navigationController)
        case .album:
            return AlbumCoordinator(navigationController: navigationController)
        case .search:
            return SearchCoordinator(navigationController: navigationController)
        }
    }
}
