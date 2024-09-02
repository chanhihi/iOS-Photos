//
//  FullScreenContentCoordinator.swift
//  iOSmediaItemss
//
//  Created by Chan on 8/30/24.
//

import UIKit
import AVKit

final class FullScreenContentCoordinator: NSObject, Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType = .fullScreenContent
    private var fullScreenContentViewController: FullScreenContentViewController?
    
    private let mediaItemsStore: MediaItemsStore
    private let startIndex: Int
    private let startImageView: UIImageView
    
    init(navigationController: UINavigationController, mediaItemsStore: MediaItemsStore, startIndex: Int, startImageView: UIImageView) {
        self.navigationController = navigationController
        self.mediaItemsStore = mediaItemsStore
        self.startIndex = startIndex
        self.startImageView = startImageView
        super.init()
    }
    
    func start() {
        let viewModel = FullScreenContentViewModel(coordinator: self, mediaItemsStore: mediaItemsStore, startIndex: startIndex)
        fullScreenContentViewController = FullScreenContentViewController(viewModel: viewModel)
        showFullScreenContent(from: startImageView, to: fullScreenContentViewController!)
    }
    
    private func showFullScreenContent(from imageView: UIImageView, to viewController: UIViewController) {
        guard let window = navigationController.view.window,
              let startFrame = imageView.superview?.convert(imageView.frame, to: window),
              let fullScreenContentViewController = fullScreenContentViewController else {
            return
        }
        
        let navController = FullScreenContentNavigationController(rootViewController: fullScreenContentViewController)
        navController.modalPresentationStyle = .overFullScreen
        navController.modalTransitionStyle = .crossDissolve
        
        let transitioningDelegate = ImageTransitioningDelegate(imageView: imageView, startFrame: startFrame, finalFrame: fullScreenContentViewController.finalImageViewFrame)
        navController.transitioningDelegate = transitioningDelegate
        
        self.navigationController.present(navController, animated: true)
    }
    
}
