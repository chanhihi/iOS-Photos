//
//  FullScreenContentCoordinator.swift
//  iOSmediaItemss
//
//  Created by Chan on 8/30/24.
//

import UIKit
import AVKit

final class FullScreenContentCoordinator: Coordinator {
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
    }
    
    func start() {
        let viewModel = FullScreenContentViewModel(mediaItems: mediaItems, startIndex: startIndex)
        fullScreenContentViewController = FullScreenContentViewController(viewModel: viewModel)
        
        guard let fullScreenContentViewController = fullScreenContentViewController else { return }
        showFullScreenContent(from: startImageView, to: fullScreenContentViewController)
    }

    private func showFullScreenContent(from imageView: UIImageView, to viewController: UIViewController) {
        guard let window = navigationController.view.window,
              let startFrame = imageView.superview?.convert(imageView.frame, to: window) else {
            return
        }
        
        performTransitionAnimation(from: imageView, to: viewController, startFrame: startFrame, in: window)
    }

    private func performTransitionAnimation(from imageView: UIImageView, to viewController: UIViewController, startFrame: CGRect, in window: UIWindow) {
        let animatedImageView = UIImageView(frame: startFrame)
        animatedImageView.image = imageView.image
        animatedImageView.contentMode = .scaleAspectFit
        animatedImageView.clipsToBounds = true
        window.addSubview(animatedImageView)
        
        imageView.isHidden = true
        
        let targetSize = calculateAspectFitSize(for: imageView.image?.size ?? .zero, in: window.bounds)
        let endFrame = CGRect(x: (window.bounds.width - targetSize.width) / 2,
                              y: (window.bounds.height - targetSize.height) / 2,
                              width: targetSize.width,
                              height: targetSize.height)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            animatedImageView.frame = endFrame
        }, completion: { _ in
            self.navigationController.pushViewController(viewController, animated: false)
            animatedImageView.removeFromSuperview()
            imageView.isHidden = false
        })
    }

    private func calculateAspectFitSize(for imageSize: CGSize, in boundingRect: CGRect) -> CGSize {
        let widthRatio = boundingRect.width / imageSize.width
        let heightRatio = boundingRect.height / imageSize.height
        let scale = min(widthRatio, heightRatio)
        
        return CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
    }
}

extension FullScreenContentCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter({ $0 !== childCoordinator })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
