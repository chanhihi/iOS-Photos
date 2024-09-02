//
//  MediaItemsStore.swift
//  iOSPhotos
//
//  Created by Chan on 9/2/24.
//

import Combine
import Photos

final class MediaItemsStore: ObservableObject {
    @Published var mediaItems: [MediaItem] = []
    
    func deleteMediaItem(at index: Int) {
        guard index >= 0 && index < mediaItems.count else { return }
        mediaItems.remove(at: index)
    }
    
    func addMediaItems(_ newItems: [MediaItem]) {
        mediaItems.append(contentsOf: newItems)
    }
    
    func clearMediaItems() {
        mediaItems.removeAll()
    }
}
