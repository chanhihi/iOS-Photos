
//
//  MediaItemsRepository.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

final class MediaItemsRepository: MediaItemsRepositoryProtocol {
    private let mediaLoader: MediaLoader
    
    init(mediaLoader: MediaLoader) {
        self.mediaLoader = mediaLoader
    }
    
    func loadMediaItems(completion: @escaping ([MediaItem]) -> Void) {
        mediaLoader.currentPage = 0
        mediaLoader.loadContents { [weak self] mediaItems in
            guard let self = self else { return }
            
            let sortedItems = self.sortMediaItemsByDate(mediaItems)
            completion(sortedItems)
        }
    }
    
    func loadMoreMediaItems(completion: @escaping ([MediaItem]) -> Void) {
        mediaLoader.currentPage += 1
        mediaLoader.loadPage { [weak self] mediaItems in
            guard let self = self else { return }
            
            let sortedItems = self.sortMediaItemsByDate(mediaItems)
            completion(sortedItems)
        }
    }
    
    private func sortMediaItemsByDate(_ mediaItems: [MediaItem]) -> [MediaItem] {
        return mediaItems.sorted { (item1, item2) -> Bool in
            guard let date1 = item1.creationDate, let date2 = item2.creationDate else {
                return false
            }
            return date1 < date2
        }
    }
}
