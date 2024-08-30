//
//  StorageViewModel.swift
//  iOSPhotos
//
//  Created by Chan on 8/28/24.
//

import UIKit
import Combine

final class StorageViewModel {
    weak var coordinator: StorageCoordinator?
    private var loadMediaItemsUseCase: MediaItemsUseCaseProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var mediaItems: [MediaItem] = []
    @Published var currentLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private(set) var selectedSegmentIndex: Int = 0 {
        didSet {
            onSegmentIndexChange?(selectedSegmentIndex)
        }
    }
    var onSegmentIndexChange: ((Int) -> Void)?
        
    init(coordinator: StorageCoordinator, loadMediaItemsUseCase: MediaItemsUseCaseProtocol) {
        self.coordinator = coordinator
        self.loadMediaItemsUseCase = loadMediaItemsUseCase
        setupInitialLayout()
        loadPhotos()
    }
    
    private func setupInitialLayout() {
        let lastSelectedIndex = AppStateManager.shared.loadLastStorageSegmentedIndex()
        guard let sortType = SegmentedModel.SortType(rawValue: lastSelectedIndex)
        else { return }
        updateLayout(for: sortType)
    }
    
    func loadPhotos() {
        loadMediaItemsUseCase.execute { [weak self] loadedPhotos in
            DispatchQueue.main.async {
                self?.mediaItems = loadedPhotos
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
}
