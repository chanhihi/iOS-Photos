//
//  MediaItemState.swift
//  iOSPhotos
//
//  Created by Chan on 9/2/24.
//

import UIKit
import Photos

final class MediaItemState {
    static let shared = MediaItemState()
    private(set) var likes: [String: Bool] = [:]
    
    private init() {}
    
    func toggleLike(for asset: PHAsset) -> Bool {
        let identifier = asset.localIdentifier
        if let isLiked = likes[identifier] {
            likes[identifier] = !isLiked
            return !isLiked
        } else {
            likes[identifier] = true
            return true
        }
    }
    
    func isLiked(asset: PHAsset) -> Bool {
        return likes[asset.localIdentifier] ?? false
    }
}
