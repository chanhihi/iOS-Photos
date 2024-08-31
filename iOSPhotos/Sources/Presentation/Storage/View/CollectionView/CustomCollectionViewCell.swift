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
    private var dateLabel: UILabel?
    
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
        label.font = .boldPreferredFont(forTextStyle: .caption1)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        durationLabel = label
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            label.heightAnchor.constraint(equalToConstant: 18),
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 38)
        ])
    }
    
    private func setupDateLabel() {
        guard dateLabel == nil else { return }
        
        let label = UILabel()
        label.textColor = .white
        label.font = .boldPreferredFont(forTextStyle: .title2)
        label.textAlignment = .left
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        dateLabel = label
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.heightAnchor.constraint(equalToConstant: 18),
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
    
    private func formatDuration(_ duration: Double) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func formatDate(_ date: Date, for segmentIndex: SegmentedModel.SortType) -> String {
        let formatter = DateFormatter()
        switch segmentIndex {
        case .year:
            formatter.dateFormat = "yyyy년"
        case .month:
            formatter.dateFormat = "M월 d일"
        default:
            formatter.dateStyle = .short
            formatter.timeStyle = .none
        }
        return formatter.string(from: date)
    }
    
    func configure(with mediaItem: MediaItem, segmentIndex: SegmentedModel.SortType) {
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
        
        if (segmentIndex == SegmentedModel.SortType.year || segmentIndex == SegmentedModel.SortType.month), let creationDate = mediaItem.creationDate {
            setupDateLabel()
            dateLabel?.text = formatDate(creationDate, for: segmentIndex)
        } else {
            dateLabel?.removeFromSuperview()
            dateLabel = nil
        }
    }
}
