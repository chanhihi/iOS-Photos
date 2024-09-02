
//
//  MediaItemsRepository.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

final class MediaItemsRepository: MediaItemsRepositoryProtocol {
    private let mediaItemsLibraryDataSource: MediaItemsLibraryDataSource
    private let mediaLoader: MediaLoader
    
    init(mediaItemsLibraryDataSource: MediaItemsLibraryDataSource, mediaLoader: MediaLoader) {
        self.mediaItemsLibraryDataSource = mediaItemsLibraryDataSource
        self.mediaLoader = mediaLoader
    }
    
    func loadMediaItems(completion: @escaping ([MediaItem]) -> Void) {
//        초기 전체를 통으로 불러오던 메소드
//        mediaItemsLibraryDataSource.loadContents { mediaItems in
//            completion(mediaItems)
//        }
        
        mediaLoader.loadContents(completion: { mediaItems in
            completion(mediaItems)
        })
    }
    
    func loadMoreMediaItems(completion: @escaping ([MediaItem]) -> Void) {
        mediaLoader.loadContents(completion: { mediaItems in
            completion(mediaItems)
        })
    }
}
