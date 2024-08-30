
//
//  MediaItemsRepository.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

final class MediaItemsRepository: MediaItemsRepositoryProtocol {
    private let mediaItemsLibraryDataSource: MediaItemsLibraryDataSource
    
    init(mediaItemsLibraryDataSource: MediaItemsLibraryDataSource) {
        self.mediaItemsLibraryDataSource = mediaItemsLibraryDataSource
    }
    
    func loadMediaItems(completion: @escaping ([MediaItem]) -> Void) {
        mediaItemsLibraryDataSource.loadContents { mediaItems in
            completion(mediaItems)
        }
    }
}
