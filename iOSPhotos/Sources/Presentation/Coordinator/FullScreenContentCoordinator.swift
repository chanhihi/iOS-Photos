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
    
    private let mediaItems: [MediaItem]
    private let startIndex: Int
    private let startImageView: UIImageView
    
    init(navigationController: UINavigationController, mediaItems: [MediaItem], startIndex: Int, startImageView: UIImageView) {
        self.navigationController = navigationController
        self.mediaItems = mediaItems
        self.startIndex = startIndex
        self.startImageView = startImageView
        super.init()
        //        self.navigationController.delegate = self
    }
    
    func start() {
        let viewModel = FullScreenContentViewModel(coordinator: self, mediaItems: mediaItems, startIndex: startIndex)
        fullScreenContentViewController = FullScreenContentViewController(viewModel: viewModel)
        showFullScreenContent(from: startImageView, to: fullScreenContentViewController!)
    }
    
    private func showFullScreenContent(from imageView: UIImageView, to viewController: UIViewController) {
        guard let window = navigationController.view.window,
              let startFrame = imageView.superview?.convert(imageView.frame, to: window) else {
            return
        }
        
        let transitioningDelegate = ImageTransitioningDelegate(imageView: imageView, startFrame: startFrame, finalFrame: fullScreenContentViewController?.finalImageViewFrame)
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        viewController.transitioningDelegate = transitioningDelegate
        self.navigationController.present(viewController, animated: true)
        
        //        self.navigationController.pushViewController(viewController, animated: true)
    }
    
}

//extension FullScreenContentCoordinator: UINavigationControllerDelegate {
//    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if operation == .push && toVC is FullScreenContentViewController {
//            let startFrame = startImageView.superview?.convert(startImageView.frame, to: nil) ?? CGRect.zero
//            return ImageTransitionAnimator(imageView: startImageView, startFrame: startFrame, finalFrame: fullScreenContentViewController?.finalImageViewFrame)
//        }
//        return nil
//    }
//}
//
