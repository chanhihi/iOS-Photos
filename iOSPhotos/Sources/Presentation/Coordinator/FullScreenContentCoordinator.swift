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
        let currentMediaItems = mediaItems[startIndex]
        
        switch currentMediaItems.mediaType {
        case .image:
            showFullScreenImage(from: startImageView, to: currentMediaItems)
        case .video:
            playFullScreenVideo(with: currentMediaItems)
        default:
            break
        }
    }
    
    private func showFullScreenImage(from imageView: UIImageView, to mediaItem: MediaItem) {
        guard let window = self.navigationController.view.window,
              let startFrame = imageView.superview?.convert(imageView.frame, to: window) else {
            return
        }
        
        let fullScreenContentViewController = FullScreenContentViewController(mediaItems: mediaItems, startIndex: startIndex)
        performImageTransition(from: imageView, to: fullScreenContentViewController, with: mediaItem, startFrame: startFrame, in: window)
    }
    
    private func performImageTransition(from imageView: UIImageView, to viewController: UIViewController, with mediaItems: MediaItem, startFrame: CGRect, in window: UIWindow) {
        let animatedImageView = UIImageView(frame: startFrame)
        animatedImageView.image = mediaItems.image
        animatedImageView.contentMode = .scaleAspectFit
        animatedImageView.clipsToBounds = true
        window.addSubview(animatedImageView)
        
        imageView.isHidden = true
        
        let targetSize = calculateAspectFitSize(for: mediaItems.image?.size ?? .zero, in: window.bounds)
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
    
    private func playFullScreenVideo(with mediaItems: MediaItem) {
        guard let videoURL = mediaItems.videoURL else { return }
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        navigationController.present(playerViewController, animated: true) {
            player.play()
        }
    }
    
    private func calculateAspectFitSize(for imageSize: CGSize, in boundingRect: CGRect) -> CGSize {
        let widthRatio = boundingRect.width / imageSize.width
        let heightRatio = boundingRect.height / imageSize.height
        let scale = min(widthRatio, heightRatio)
        
        return CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
    }
}
