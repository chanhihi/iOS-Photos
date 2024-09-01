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
    weak var coordinator: FullScreenContentCoordinator?
    var mediaItems: [MediaItem]
    @Published var currentIndex: Int
    @Published var viewControllerBackgroundColorAlpha: CGFloat = 1
    var cancellables: Set<AnyCancellable> = []
    
    init(coordinator: FullScreenContentCoordinator, mediaItems: [MediaItem], startIndex: Int = 0) {
        self.coordinator = coordinator
        self.mediaItems = mediaItems
        self.currentIndex = startIndex
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
        // ViewModel should not directly handle UI, so it returns info for viewController to display
        print(metadataInfo)  // Replace print statement with a delegate or callback to handle in viewController
    }

    
    func deleteCurrentItem() {
        guard !mediaItems.isEmpty else { return }
        mediaItems.remove(at: currentIndex)

        if mediaItems.isEmpty {
            // dismiss
        } else {
            currentIndex = max(0, currentIndex - 1)
        }
    }
    
    func shareContent() {
        guard mediaItems.indices.contains(currentIndex) else { return }
        let currentItem = mediaItems[currentIndex]
        // 공유 로직 구현, 예: UIActivityViewController 사용
        // 주의: 뷰 모델에서 직접 UI를 호출하지 않도록 설계하는 것이 좋음 (Coordinator나 ViewController를 통해 처리)
        print("Share item \(currentItem)")
    }

    func likeContent() {
        guard mediaItems.indices.contains(currentIndex) else { return }
        // 좋아요 토글 기능 구현
        // 예: 데이터베이스나 로컬 저장소에 좋아요 상태 업데이트
        print("Liked item at index \(currentIndex)")
    }
}
