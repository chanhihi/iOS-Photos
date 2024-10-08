//
//  MediaItemCell.swift
//  iOSPhotos
//
//  Created by Chan on 8/31/24.
//

import UIKit
import AVKit
import Photos

final class MediaItemCell: UICollectionViewCell {
    static let reuseIdentifier = "MediaItemCell"
    private let scrollView = UIScrollView()
    let imageView = UIImageView()
    private let imageManager = PHCachingImageManager()
    private var imageRequestID: PHImageRequestID?
    private var videoContainerView = UIView()
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private var initialCenter = CGPoint()
    var onDismissRequested: (() -> Void)?
    var adjustAlpha: ((CGFloat) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        addPanGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopPlayback()
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player = nil
        
        if let requestID = imageRequestID {
            imageManager.cancelImageRequest(requestID)
            imageRequestID = nil
        }
        imageView.image = nil
    }
    
    private func setupUI() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        imageView.contentMode = .scaleAspectFit
    }
    
    private func setupLayout() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(videoContainerView)
        
        scrollView.frame = contentView.bounds
        imageView.frame = scrollView.bounds
        videoContainerView.frame = scrollView.bounds
    }
    
    func configure(with mediaItem: MediaItem) {
        switch mediaItem.mediaType {
        case .image:
            prepareForImageDisplay()
            loadHighResolutionImage(for: mediaItem)
        case .video:
            prepareForVideoDisplay(mediaItem.videoURL)
        default:
            break
        }
    }
    
    private func prepareForImageDisplay() {
        playerLayer?.player?.pause()
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        imageView.isHidden = false
        scrollView.isHidden = false
    }
    
    private func loadHighResolutionImage(for mediaItem: MediaItem) {
        guard let asset = mediaItem.asset else { return }
        if let requestID = imageRequestID {
            imageManager.cancelImageRequest(requestID)
        }
        
        let targetSize = CGSize(width: mediaItem.pixelWidth, height: mediaItem.pixelHeight)
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.resizeMode = .exact
        options.isSynchronous = false
        
        imageRequestID = imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { [weak self] (image, info) in
            guard let self = self else { return }
            
            if let error = info?[PHImageErrorKey] as? Error {
                print("Error loading high-resolution image: \(error.localizedDescription)")
                self.loadLowResolutionImage(for: mediaItem)
            } else if let isDegraded = info?[PHImageResultIsDegradedKey] as? Bool, !isDegraded, let image = image {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } else {
                print("Failed to load high-resolution image for asset: \(asset.localIdentifier)")
                self.loadLowResolutionImage(for: mediaItem)
            }
        }
    }
    
    private func loadLowResolutionImage(for mediaItem: MediaItem) {
        guard let asset = mediaItem.asset else { return }
        
        let targetSize = CGSize(width: 150, height: 150)
        let options = PHImageRequestOptions()
        options.deliveryMode = .fastFormat
        options.isSynchronous = false
        
        imageRequestID = imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { [weak self] (image, info) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let image = image {
                    self.imageView.image = image
                }
            }
        }
    }
    
    private func prepareForVideoDisplay(_ videoURL: URL?) {
        guard let videoURL = videoURL else { return }
        imageView.isHidden = true
        player?.pause()
        
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoContainerView.bounds
        if let layer = playerLayer {
            videoContainerView.layer.addSublayer(layer)
        }
    }
    
    func startPlayback() {
        player?.play()
    }
    
    
    func stopPlayback() {
        player?.pause()
    }
    
    private func addPanGestureToVideoPlayer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        scrollView.addGestureRecognizer(panGesture)
    }
    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        scrollView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let maxTranslation: CGFloat = 150
        let minAlpha: CGFloat = 0
        let maxAlpha: CGFloat = 1
        let threshold: CGFloat = 100
        
        switch gesture.state {
        case .began:
            initialCenter = self.center
            adjustAlpha?(maxAlpha)
        case .changed:
            self.center = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            let alphaAdjustment = max(minAlpha, maxAlpha - (translation.y / maxTranslation) * (maxAlpha - minAlpha))
            adjustAlpha?(alphaAdjustment)
        case .ended:
            if translation.y > threshold {
                animateDismiss(initialCenter: initialCenter)
                adjustAlpha?(minAlpha)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.center = self.initialCenter
                    self.adjustAlpha?(1)
                }
            }
        default:
            break
        }
    }
    
    private func animateDismiss(initialCenter: CGPoint) {
        UIView.animate(withDuration: 0.2, animations: {
            let screenHeight = UIScreen.main.bounds.height
            self.center = CGPoint(x: initialCenter.x, y: screenHeight + self.frame.height / 2)
            self.alpha = 0
        }, completion: { _ in
            self.onDismissRequested?()
        })
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
        if !imageView.isHidden {
            return imageView
        } else if !videoContainerView.isHidden {
            return videoContainerView
        }
        return nil
    }
}
