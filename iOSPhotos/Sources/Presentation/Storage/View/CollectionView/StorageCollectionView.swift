//
//  StorageCollectionView.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

final class StorageCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var mediaItems: [MediaItem] = []
    private var viewModel: StorageViewModel?
    
    init(layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout(), viewModel: StorageViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero, collectionViewLayout: layout)
        setupProperty()
        setupUI()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProperty() {
        self.delegate = self
        self.dataSource = self
        self.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func setupUI() {
        self.backgroundColor = .secondarySystemBackground
    }
    
    private func setupBindings() {
        viewModel?.onSegmentIndexChange = { [weak self] index in
            self?.reloadData()
        }
    }
    
    func updateLayout(_ layout: UICollectionViewFlowLayout) {
        UIView.animate(withDuration: 0.3) {
            self.setCollectionViewLayout(layout, animated: true)
        }
    }
    
    func setMediaItems(_ mediaItems: [MediaItem]) {
        self.mediaItems = mediaItems
        self.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mediaItem = mediaItems[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        configureCell(cell, with: mediaItem)
        
        return cell
    }
    
    private func configureCell(_ cell: CustomCollectionViewCell, with mediaItem: MediaItem) {
        cell.configure(with: mediaItem)
        let segmentedIndex = AppStateManager.shared.loadLastStorageSegmentedIndex()
        if (SegmentedModel.SortType.year.rawValue == segmentedIndex || SegmentedModel.SortType.month.rawValue == segmentedIndex) {
            cell.layer.cornerRadius = .collectionViewCornerRadiusYearMonth
            cell.clipsToBounds = true
        } else {
            cell.layer.cornerRadius = .collectionViewCornerRadiusDayAll
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let segmentedIndex = AppStateManager.shared.loadLastStorageSegmentedIndex()
        
        if segmentedIndex == SegmentedModel.SortType.day.rawValue || segmentedIndex == SegmentedModel.SortType.all.rawValue {
            let selectedPhoto = mediaItems[indexPath.row]
            
            guard let selectedCell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell else {
                return
            }
            
            viewModel?.didSelectPhoto(selectedPhoto, from: selectedCell.imageView)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Methods
extension StorageCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .collectionViewMinimumInterSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .collectionViewMinimumLineSpacing
    }
}
