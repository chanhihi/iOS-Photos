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
    private var finalFrame: CGRect?

    init(imageView: UIImageView, startFrame: CGRect, finalFrame: CGRect?) {
        self.imageView = imageView
        self.startFrame = startFrame
        self.finalFrame = finalFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        toView.alpha = 0
        toView.isHidden = true
        
        let backgroundView = UIView(frame: containerView.bounds)
        backgroundView.backgroundColor = UIColor.systemBackground
        backgroundView.alpha = 0
        containerView.addSubview(backgroundView)
        
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
            backgroundView.alpha = 1
            toView.alpha = 1
            animatedImageView.frame = self.finalFrame ?? endFrame
        }, completion: { _ in
            animatedImageView.removeFromSuperview()
            backgroundView.removeFromSuperview()
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
