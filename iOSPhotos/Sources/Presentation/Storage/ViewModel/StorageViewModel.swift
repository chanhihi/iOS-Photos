//
//  StorageViewModel.swift
//  iOSPhotos
//
//  Created by Chan on 8/28/24.
//

import UIKit
import Combine

final class StorageViewModel {
    private var photoManager = PhotoManager()
    @Published var photos: [UIImage] = []
    @Published var currentLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
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
        photoManager.loadPhotos { [weak self] loadedPhotos in
            DispatchQueue.main.async {
                self?.photos = loadedPhotos
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
    }
    
}
