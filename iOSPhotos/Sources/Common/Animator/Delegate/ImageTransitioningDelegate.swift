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

    init(imageView: UIImageView, startFrame: CGRect) {
        self.imageView = imageView
        self.startFrame = startFrame
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageTransitionAnimator(imageView: imageView, startFrame: startFrame)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
