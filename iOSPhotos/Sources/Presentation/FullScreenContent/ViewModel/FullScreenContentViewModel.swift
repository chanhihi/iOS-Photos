//
//  FullScreenContentViewModel.swift
//  iOSPhotos
//
//  Created by Chan on 8/31/24.
//

import UIKit
import Combine
import Photos

final class FullScreenContentViewModel {
    weak var coordinator: FullScreenContentCoordinator?
    let mediaItemsStore: MediaItemsStore
    @Published var currentIndex: Int
    @Published var viewControllerBackgroundColorAlpha: CGFloat = 1
    @Published var highResolutionImage: UIImage?
    private let imageManager = PHCachingImageManager()
    var cancellables: Set<AnyCancellable> = []
    
    init(coordinator: FullScreenContentCoordinator, mediaItemsStore: MediaItemsStore, startIndex: Int = 0) {
        self.coordinator = coordinator
        self.mediaItemsStore = mediaItemsStore
        self.currentIndex = startIndex
        loadHighResolutionImage(for: currentIndex)
    }
    
    func dismissViewController() {
        coordinator?.finish()
    }
    
    func adjustAlpha(_ newAlpha: CGFloat) {
        viewControllerBackgroundColorAlpha = newAlpha
    }
    
    func getMetaDataInfo() -> String {
        guard currentIndex < mediaItemsStore.mediaItems.count else { return "No metadata available." }
        let item = mediaItemsStore.mediaItems[currentIndex]
        let metadataInfo = """
        Date: \(item.creationDate ?? Date())
        Location: \(item.location?.coordinate.latitude ?? 0), \(item.location?.coordinate.longitude ?? 0)
        Resolution: \(item.pixelWidth)x\(item.pixelHeight)
        Type: \(item.mediaType)
        """
        return metadataInfo
    }
    
    func deleteCurrentItem() {
        guard !mediaItemsStore.mediaItems.isEmpty else {
            dismissViewController()
            return
        }
        
        mediaItemsStore.mediaItems.remove(at: currentIndex)
        
        if mediaItemsStore.mediaItems.isEmpty {
            dismissViewController()
            return
        }
        
        if currentIndex >= mediaItemsStore.mediaItems.count {
            currentIndex = mediaItemsStore.mediaItems.count - 1
        }
        
        loadHighResolutionImage(for: currentIndex)
        dismissViewController()
    }
    
    func likeContent() -> Bool? {
        guard mediaItemsStore.mediaItems.indices.contains(currentIndex), let asset = mediaItemsStore.mediaItems[currentIndex].asset else { return nil }
        return MediaItemState.shared.toggleLike(for: asset)
    }
    
    func isLikedCurrentItem() -> Bool {
        guard mediaItemsStore.mediaItems.indices.contains(currentIndex), let asset = mediaItemsStore.mediaItems[currentIndex].asset else { return false }
        return MediaItemState.shared.isLiked(asset: asset)
    }
    
    func loadHighResolutionImage(for index: Int) {
        guard mediaItemsStore.mediaItems.indices.contains(index) else { return }
        let item = mediaItemsStore.mediaItems[index]
        
        guard let asset = item.asset else { return }
        let targetSize = CGSize(width: item.pixelWidth, height: item.pixelHeight)
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { [weak self] (image, _) in
            DispatchQueue.main.async {
                self?.highResolutionImage = image
            }
        }
    }
    
    func didChangeIndex(to newIndex: Int) {
        guard newIndex != currentIndex else { return }
        currentIndex = newIndex
        loadHighResolutionImage(for: currentIndex)
    }
}
