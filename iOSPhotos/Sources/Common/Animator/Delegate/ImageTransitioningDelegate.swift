//
//  ImageTransitioningDelegate.swift
//  iOSPhotos
//
//  Created by Chan on 9/1/24.
//

import UIKit

class ImageTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private let imageView: UIImageView
    private let startFrame: CGRect
    private let finalFrame: CGRect?

    init(imageView: UIImageView, startFrame: CGRect, finalFrame: CGRect?) {
        self.imageView = imageView
        self.startFrame = startFrame
        self.finalFrame = finalFrame
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageTransitionAnimator(imageView: imageView, startFrame: startFrame, finalFrame: finalFrame)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
