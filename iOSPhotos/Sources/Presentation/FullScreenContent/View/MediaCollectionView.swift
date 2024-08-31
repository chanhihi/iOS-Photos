//
//  MediaCollectionView.swift
//  iOSPhotos
//
//  Created by Chan on 8/31/24.
//

import UIKit

final class MediaCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var viewModel: FullScreenContentViewModel
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, viewModel: FullScreenContentViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame, collectionViewLayout: layout)
        setupProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProperty() {
        backgroundColor = .clear
        dataSource = self
        delegate = self
        self.isPagingEnabled = true
        register(MediaItemCell.self, forCellWithReuseIdentifier: MediaItemCell.reuseIdentifier)
        
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            let initialIndexPath = IndexPath(item: self.viewModel.currentIndex, section: 0)
            self.scrollToItem(at: initialIndexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaItemCell.reuseIdentifier, for: indexPath) as! MediaItemCell
        
        cell.onDismissRequested = { [weak self] in
            self?.viewModel.dismissViewController()
        }
        
        cell.adjustAlpha = { [weak self] newAlpha in
            self?.viewModel.adjustAlpha(newAlpha)
        }
        
        cell.configure(with: viewModel.mediaItems[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let visibleIndexPath = collectionView.indexPathsForVisibleItems.first else { return }
        viewModel.currentIndex = visibleIndexPath.item
    }
}
