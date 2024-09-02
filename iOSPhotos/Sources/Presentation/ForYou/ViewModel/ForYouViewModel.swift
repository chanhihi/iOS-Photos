//
//  ForYouViewModel.swift
//  iOSPhotos
//
//  Created by Chan on 8/29/24.
//

import Foundation
import Combine
import Photos

final class ForYouViewModel: NSObject {
    weak var coordinator: ForYouCoordinator?
    private var loadMediaItemsUseCase: MediaItemsUseCaseProtocol
    
    @Published var mediaItems: [MediaItem] = []
    @Published var photos: [MediaItem] = []
    @Published var videos: [MediaItem] = []
    
    var cancellables: Set<AnyCancellable> = []
    
    init(coordinator: ForYouCoordinator, loadMediaItemsUseCase: MediaItemsUseCaseProtocol) {
        self.coordinator = coordinator
        self.loadMediaItemsUseCase = loadMediaItemsUseCase
        super.init()
        
        PHPhotoLibrary.shared().register(self)
        
        bindMediaItems()
        loadMediaItems()
    }
    
    private func bindMediaItems() {
        $mediaItems
            .sink { [weak self] items in
                self?.photos = items.filter { $0.mediaType == .image }
                self?.videos = items.filter { $0.mediaType == .video }
            }
            .store(in: &cancellables)
    }
    
    func loadMediaItems() {
        loadMediaItemsUseCase.execute { [weak self] loadedMediaItems in
            DispatchQueue.main.async {
                self?.mediaItems = loadedMediaItems
            }
        }
    }
}

extension ForYouViewModel: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        loadMediaItems()
    }
}
