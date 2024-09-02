//
//  ForYouCoordinator.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

final class ForYouCoordinator: ForYouCoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    var forYouViewController: ForYouViewController
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType = .foryou
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.forYouViewController = ForYouViewController()
    }

    func start() {
        self.forYouViewController.viewModel = createForYouViewModel()
        navigationController.viewControllers = [forYouViewController]
    }
    
    private func createForYouViewModel() -> ForYouViewModel {
        let mediaItemsLibraryDataSource = MediaItemsLibraryDataSource()
        let mediaLoader = MediaLoader()
        
        let repository = MediaItemsRepository(mediaItemsLibraryDataSource: mediaItemsLibraryDataSource, mediaLoader: mediaLoader)
        
        let useCase = LoadPhotosUseCase(repository: repository)
        return ForYouViewModel(coordinator: self, loadMediaItemsUseCase: useCase)
    }
    
}

extension ForYouCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
