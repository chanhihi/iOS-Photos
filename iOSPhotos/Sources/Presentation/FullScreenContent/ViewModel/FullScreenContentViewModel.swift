//
//  FullScreenContentViewModel.swift
//  iOSPhotos
//
//  Created by Chan on 8/31/24.
//

import UIKit
import Combine

//import AVKit

final class FullScreenContentViewModel {
    var mediaItems: [MediaItem]
    @Published var currentIndex: Int
    var cancellables: Set<AnyCancellable> = []
    
    init(mediaItems: [MediaItem], startIndex: Int = 0) {
        self.mediaItems = mediaItems
        self.currentIndex = startIndex
    }
    
    func showMetaData() {
        guard mediaItems[currentIndex].mediaType == .image else { return }
        let metaDataViewController = MetaDataViewController(image: mediaItems[currentIndex].image!)
        UIApplication.shared.windows.first?.rootViewController?.present(metaDataViewController, animated: true)
    }
    
    func deleteCurrentItem() {
        guard !mediaItems.isEmpty else { return }
        mediaItems.remove(at: currentIndex)

        if mediaItems.isEmpty {
            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
        } else {
            currentIndex = max(0, currentIndex - 1)
        }
    }
}
