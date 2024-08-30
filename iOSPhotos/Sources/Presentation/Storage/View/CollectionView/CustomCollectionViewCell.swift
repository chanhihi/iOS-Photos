//
//  CustomCollectionViewCell.swift
//  iOSPhotos
//
//  Created by Chan on 8/29/24.
//

import UIKit

final class CustomCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    private var durationLabel: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupDurationLabel() {
        guard durationLabel == nil else { return }
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        durationLabel = label
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 2),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 2),
            label.heightAnchor.constraint(equalToConstant: 18),
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 38)
        ])
    }

    private func formatDuration(_ duration: Double) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    func configure(with mediaItem: MediaItem) {
        imageView.image = mediaItem.image
        
        switch mediaItem.mediaType {
        case .image:
            durationLabel?.removeFromSuperview()
            durationLabel = nil
        case .video:
            setupDurationLabel()
            if let duration = mediaItem.duration {
                durationLabel?.text = formatDuration(duration)
            }
        default:
            break
        }
    }
}
