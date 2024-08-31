//
//  ImageTransitionAnimator.swift
//  iOSPhotos
//
//  Created by Chan on 9/1/24.
//

import UIKit

class ImageTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let imageView: UIImageView
    private let startFrame: CGRect

    init(imageView: UIImageView, startFrame: CGRect) {
        self.imageView = imageView
        self.startFrame = startFrame
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        let animatedImageView = UIImageView(frame: startFrame)
        animatedImageView.image = imageView.image
        animatedImageView.contentMode = .scaleAspectFit
        animatedImageView.clipsToBounds = true
        containerView.addSubview(toView)
        containerView.addSubview(animatedImageView)
        toView.isHidden = true

        imageView.isHidden = true

        let targetSize = calculateAspectFitSize(for: imageView.image?.size ?? .zero, in: containerView.bounds)
        let endFrame = CGRect(x: (containerView.bounds.width - targetSize.width) / 2,
                              y: (containerView.bounds.height - targetSize.height) / 2,
                              width: targetSize.width,
                              height: targetSize.height)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            animatedImageView.frame = endFrame
        }, completion: { _ in
            animatedImageView.removeFromSuperview()
            toView.isHidden = false
            self.imageView.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    private func calculateAspectFitSize(for size: CGSize, in boundingRect: CGRect) -> CGSize {
        guard size.width > 0 && size.height > 0 else { return .zero }

        let widthRatio = boundingRect.width / size.width
        let heightRatio = boundingRect.height / size.height
        let scale = min(widthRatio, heightRatio)

        return CGSize(width: size.width * scale, height: size.height * scale)
    }
}
