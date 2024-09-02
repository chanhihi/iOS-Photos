//
//  StorageCollectionView.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit
import Combine

final class StorageCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var mediaItems: [MediaItem] = []
    private var viewModel: StorageViewModel?
    private var isLoadingMoreItems = false
    
    init(layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout(), viewModel: StorageViewModel) {
        self.viewModel = viewModel
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
        self.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func setupUI() {
        self.backgroundColor = .secondarySystemBackground
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
    
    func addMediaItems(_ newItems: [MediaItem]) {
        let startIndex = self.mediaItems.count
        self.mediaItems.append(contentsOf: newItems)
        
        let indexPaths = (startIndex..<self.mediaItems.count).map { IndexPath(item: $0, section: 0) }
        self.insertItems(at: indexPaths)
    }
    
    func updateVisibleCells() {
        for cell in self.visibleCells {
            if let customCell = cell as? CustomCollectionViewCell, let indexPath = self.indexPath(for: customCell) {
                let mediaItem = mediaItems[indexPath.row]
                configureCell(customCell, with: mediaItem, isHighResolution: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mediaItem = mediaItems[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        configureCell(cell, with: mediaItem, isHighResolution: false)
        
        return cell
    }
    
    private func configureCell(_ cell: CustomCollectionViewCell, with mediaItem: MediaItem, isHighResolution: Bool) {
        cell.configure(with: mediaItem, segmentIndex: SegmentedModel.SortType(rawValue: (viewModel?.selectedSegmentIndex)!) ?? SegmentedModel.SortType.all)
        
        let segmentedIndex = AppStateManager.shared.loadLastStorageSegmentedIndex()
        if (SegmentedModel.SortType.year.rawValue == segmentedIndex || SegmentedModel.SortType.month.rawValue == segmentedIndex) {
            cell.layer.cornerRadius = .collectionViewCornerRadiusYearMonth
            cell.clipsToBounds = true
        } else if (SegmentedModel.SortType.day.rawValue == segmentedIndex || SegmentedModel.SortType.all.rawValue == segmentedIndex) {
            cell.layer.cornerRadius = .collectionViewCornerRadiusDayAll
        }
        
        cell.configure(with: mediaItem, isHighResolution: isHighResolution)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let segmentedIndex = AppStateManager.shared.loadLastStorageSegmentedIndex()
        
        if segmentedIndex == SegmentedModel.SortType.day.rawValue || segmentedIndex == SegmentedModel.SortType.all.rawValue {
            let selectedPhoto = mediaItems[indexPath.row]
            guard let selectedCell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell else { return }
            viewModel?.didSelectPhoto(selectedPhoto, from: selectedCell.imageView)
        } else {
            self.viewModel?.updateSegmentIndex(to: segmentedIndex + 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let customCell = cell as? CustomCollectionViewCell else { return }
        let mediaItem = mediaItems[indexPath.row]
        let segmentedIndex = AppStateManager.shared.loadLastStorageSegmentedIndex()
        configureCell(customCell, with: mediaItem, isHighResolution: SegmentedModel.SortType.all.rawValue != segmentedIndex ? true : false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let customCell = cell as? CustomCollectionViewCell else { return }
        
        guard indexPath.row < mediaItems.count else {
            print("Invalid index path: \(indexPath.row) for mediaItems count: \(mediaItems.count)")
            return
        }
        
        customCell.cancelImageRequest()
    }
}

extension StorageCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .collectionViewMinimumInterSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .collectionViewMinimumLineSpacing
    }
}

extension StorageCollectionView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoadingMoreItems else { return }
        
        let threshold: CGFloat = 100.0
        let contentOffsetY = scrollView.contentOffset.y
        let maximumOffsetY = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffsetY - contentOffsetY <= threshold {
            isLoadingMoreItems = true
            loadMoreItems()
        }
    }
    
    private func loadMoreItems() {
        viewModel?.loadMoreMediaItems() { [weak self] in
            guard let self = self else { return }
            self.isLoadingMoreItems = false
        }
    }
}
