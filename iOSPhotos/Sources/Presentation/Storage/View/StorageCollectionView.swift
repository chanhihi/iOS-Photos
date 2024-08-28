//
//  StorageCollectionView.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

final class StorageCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var photos: [UIImage] = []
    
    init(layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()) {
        super.init(frame: .zero, collectionViewLayout: layout)
        setupProperty()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProperty() {
        self.delegate = self
        self.dataSource = self
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func setupUI() {
        self.backgroundColor = .secondarySystemBackground
    }
    
    func updateLayout(_ layout: UICollectionViewFlowLayout) {
        UIView.animate(withDuration: 0.3) {
            self.setCollectionViewLayout(layout, animated: true)
        }
    }
    
    func setPhotos(_ photos: [UIImage]) {
        self.photos = photos
        self.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        configureCell(cell, with: photos[indexPath.row])
        return cell
    }
    
    private func configureCell(_ cell: UICollectionViewCell, with image: UIImage) {
        let imageView = cell.contentView.viewWithTag(100) as? UIImageView ?? UIImageView(frame: cell.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        if imageView.superview == nil {
            cell.contentView.addSubview(imageView)
            setupImageViewConstraints(imageView)
        }
    }
    
    private func setupImageViewConstraints(_ imageView: UIImageView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: imageView.superview!.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageView.superview!.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageView.superview!.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageView.superview!.trailingAnchor)
        ])
    }
    
}
