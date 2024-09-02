//
//  StorageViewModel.swift
//  iOSPhotos
//
//  Created by Chan on 8/28/24.
//

import UIKit
import Combine
import Photos

final class StorageViewModel: NSObject {
    weak var coordinator: StorageCoordinator?
    private var loadMediaItemsUseCase: MediaItemsUseCaseProtocol
    
    @Published var mediaItems: [MediaItem] = []
    @Published var currentLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    @Published var selectedSegmentIndex: Int = SegmentedModel.SortType.all.rawValue
    
    var cancellables: Set<AnyCancellable> = []
    
    init(coordinator: StorageCoordinator, loadMediaItemsUseCase: MediaItemsUseCaseProtocol) {
        self.coordinator = coordinator
        self.loadMediaItemsUseCase = loadMediaItemsUseCase
        super.init()
        PHPhotoLibrary.shared().register(self)
        
        setupInitialLayout()
        loadMediaItems()
    }
    
    private func setupInitialLayout() {
        let lastSelectedIndex = AppStateManager.shared.loadLastStorageSegmentedIndex()
        guard let sortType = SegmentedModel.SortType(rawValue: lastSelectedIndex) else { return }
        updateLayout(for: sortType)
        selectedSegmentIndex = lastSelectedIndex
    }
    
    func loadMediaItems() {
        loadMediaItemsUseCase.execute { [weak self] loadedMediaItems in
            DispatchQueue.main.async {
                self?.mediaItems = loadedMediaItems
            }
        }
    }
    
    func updateLayout(for sortType: SegmentedModel.SortType) {
        let layout = UICollectionViewFlowLayout()
        switch sortType {
        case .year:
            layout.itemSize = .yearSize
            layout.sectionInset = .yearEdgeInset
        case .month:
            layout.itemSize = .monthSize
            layout.sectionInset = .monthEdgeInset
        case .day:
            layout.itemSize = .daySize
            layout.sectionInset = .dayEdgeInset
        case .all:
            layout.itemSize = .allSize
            layout.sectionInset = .allEdgeInset
        }
        
        DispatchQueue.main.async {
            self.currentLayout = layout
        }
        
        selectedSegmentIndex = sortType.rawValue
    }
    
    func didSelectPhoto(_ mediaItem: MediaItem, from imageView: UIImageView) {
        guard let index = mediaItems.firstIndex(where: { $0 == mediaItem }) else { return }
        coordinator?.showFullScreenContent(from: imageView, mediaItems: mediaItems, startIndex: index)
    }
    
    func updateSegmentIndex(to index: Int) {
        guard let sortType = SegmentedModel.SortType(rawValue: index) else { return }
        AppStateManager.shared.saveLastStorageSegmentedIndex(index)
        updateLayout(for: sortType)
    }
}

extension StorageViewModel: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        loadMediaItems()
    }
}
