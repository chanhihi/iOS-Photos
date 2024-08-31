//
//  MediaItemCell.swift
//  iOSPhotos
//
//  Created by Chan on 8/31/24.
//

import UIKit
import AVKit

final class MediaItemCell: UICollectionViewCell {
    static let reuseIdentifier = "MediaItemCell"
    private let scrollView = UIScrollView()
    let imageView = UIImageView()
    private var playerViewController: AVPlayerViewController?
    private var initialCenter = CGPoint()
    var onDismissRequested: (() -> Void)?
    var adjustAlpha: ((CGFloat) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addPanGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    func configure(with mediaItem: MediaItem) {
        switch mediaItem.mediaType {
        case .image:
            imageView.isHidden = false
            imageView.image = mediaItem.image
            playerViewController?.view.removeFromSuperview()
            playerViewController = nil
        case .video:
            scrollView.isHidden = true
            if let videoURL = mediaItem.videoURL {
                playerViewController = AVPlayerViewController()
                let player = AVPlayer(url: videoURL)
                playerViewController?.player = player
                playerViewController?.view.frame = contentView.bounds
                if let playerView = playerViewController?.view {
                    contentView.addSubview(playerView)
                    playerView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        playerView.topAnchor.constraint(equalTo: contentView.topAnchor),
                        playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                        playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                        playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
                    ])
                }
            }
        default:
            break
        }
    }
    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        scrollView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .began:
            initialCenter = self.center
            adjustAlpha?(0.5)  // 시작 투명도 설정

        case .changed:
            if isVertical(gesture: gesture) {
                let newCenter = CGPoint(x: initialCenter.x, y: initialCenter.y + translation.y)
                self.center = newCenter
            }
        case .ended:
            if translation.y > 100 {
                adjustAlpha?(0)

                print("Dismiss the view controller")
                onDismissRequested?()
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.center = self.initialCenter
                    self.adjustAlpha?(0.5)  // 애니메이션으로 원래 투명도 복구

                }
            }
        default:
            break
        }
    }
}

extension MediaItemCell: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = panGestureRecognizer.velocity(in: self)
            return abs(velocity.y) > abs(velocity.x)
        }
        return true
    }
    
    private func isVertical(gesture: UIPanGestureRecognizer) -> Bool {
        let velocity = gesture.velocity(in: self)
        return abs(velocity.y) > abs(velocity.x)
    }
}

extension MediaItemCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
