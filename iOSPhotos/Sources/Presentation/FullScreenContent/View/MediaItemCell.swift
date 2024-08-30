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
    private let imageView = UIImageView()
    private var playerViewController: AVPlayerViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
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
            imageView.isHidden = true
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
}
