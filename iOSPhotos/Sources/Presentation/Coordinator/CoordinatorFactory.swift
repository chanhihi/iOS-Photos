//
//  CoordinatorFactory.swift
//  iOSPhotos
//
//  Created by Chan on 8/29/24.
//

import UIKit

final class CoordinatorFactory {
    
    func createCoordinator(for type: TabBarItemType, using navigationController: UINavigationController) -> Coordinator {
        switch type {
        case .storage:
            return StorageCoordinator(navigationController: navigationController)
        case .foryou:
            return ForYouCoordinator(navigationController: navigationController)
        case .search:
            return SearchCoordinator(navigationController: navigationController)
        }
    }
    
    func createNavigationController(for type: TabBarItemType) -> UINavigationController {
        switch type {
        case .storage:
            return StorageNavigationController()
        case .foryou:
            return ForYouNavigationController()
        case .search:
            return SearchNavigationController()
        }
    }
}
