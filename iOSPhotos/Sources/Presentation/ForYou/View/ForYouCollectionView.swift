//
//  ForYouCollectionView.swift
//  iOSPhotos
//
//  Created by Chan on 8/29/24.
//

import UIKit

class ForYouCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var mediaItems: [MediaItem] = []
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        dataSource = self
        delegate = self
        backgroundColor = .clear
        register(ForYouCollectionViewCell.self, forCellWithReuseIdentifier: "ForYouCollectionViewCell")
    }
    
    func setMediaItems(_ items: [MediaItem]) {
        self.mediaItems = items
        reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForYouCollectionViewCell", for: indexPath) as! ForYouCollectionViewCell
        let mediaItem = mediaItems[indexPath.item]
        cell.configure(with: mediaItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
