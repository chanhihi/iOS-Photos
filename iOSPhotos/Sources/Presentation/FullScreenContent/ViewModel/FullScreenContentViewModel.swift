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
    var mediaItems: [MediaItem]
    @Published var currentIndex: Int
    @Published var viewControllerBackgroundColorAlpha: CGFloat = 1
    @Published var highResolutionImage: UIImage?
    private let imageManager = PHCachingImageManager()
    var cancellables: Set<AnyCancellable> = []
    
    init(coordinator: FullScreenContentCoordinator, mediaItems: [MediaItem], startIndex: Int = 0) {
        self.coordinator = coordinator
        self.mediaItems = mediaItems
        self.currentIndex = startIndex
        loadHighResolutionImage(for: currentIndex)
    }
    
    func dismissViewController() {
        coordinator?.finish()
    }
    
    func adjustAlpha(_ newAlpha: CGFloat) {
        viewControllerBackgroundColorAlpha = newAlpha
    }
    
    func showMetaData() {
        guard currentIndex < mediaItems.count else { return }
        let item = mediaItems[currentIndex]
        let metadataInfo = """
        Date: \(item.creationDate ?? Date())
        Location: \(item.location?.coordinate.latitude ?? 0), \(item.location?.coordinate.longitude ?? 0)
        Resolution: \(item.pixelWidth)x\(item.pixelHeight)
        Type: \(item.mediaType)
        """
        print(metadataInfo)
    }
    
    func deleteCurrentItem() {
        guard !mediaItems.isEmpty else { return }
        mediaItems.remove(at: currentIndex)
        
        if mediaItems.isEmpty {
            dismissViewController()
        } else {
            currentIndex = max(0, currentIndex - 1)
            loadHighResolutionImage(for: currentIndex)
        }
    }
    
    func shareContent() {
        guard mediaItems.indices.contains(currentIndex) else { return }
        let currentItem = mediaItems[currentIndex]
        print("Share item \(currentItem)")
    }

    func likeContent() {
        guard mediaItems.indices.contains(currentIndex) else { return }
        print("Liked item at index \(currentIndex)")
    }
    
    func loadHighResolutionImage(for index: Int) {
        guard mediaItems.indices.contains(index) else { return }
        let item = mediaItems[index]
        
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
