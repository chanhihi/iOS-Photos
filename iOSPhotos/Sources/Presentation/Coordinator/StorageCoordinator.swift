//
//  StorageCoordinator.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

final class StorageCoordinator: StorageCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var storageViewController: StorageViewController
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType = .storage
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.storageViewController = StorageViewController()
    }
    
    func start() {
        self.storageViewController.viewModel = createStorageViewModel()
        self.navigationController.viewControllers = [storageViewController]
    }
    
    private func createStorageViewModel() -> StorageViewModel {
        let mediaLoader = MediaLoader()
        let repository = MediaItemsRepository(mediaLoader: mediaLoader)
        let mediaItemsStore = MediaItemsStore()
        
        let useCase = LoadPhotosUseCase(repository: repository)
        return StorageViewModel(coordinator: self, loadMediaItemsUseCase: useCase, mediaItemsStore: mediaItemsStore)
    }
    
    func showFullScreenContent(from imageView: UIImageView, mediaItemsStore: MediaItemsStore, startIndex: Int) {
        let fullScreenContentCoordinator = FullScreenContentCoordinator(navigationController: navigationController, mediaItemsStore: mediaItemsStore, startIndex: startIndex, startImageView: imageView)
        fullScreenContentCoordinator.finishDelegate = self
        childCoordinators.append(fullScreenContentCoordinator)
        fullScreenContentCoordinator.start()
    }
}

extension StorageCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter({ $0 !== childCoordinator })
        childCoordinator.navigationController.dismiss(animated: false)
    }
}
