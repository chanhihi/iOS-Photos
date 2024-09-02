//
//  MediaItem.swift
//  iOSPhotos
//
//  Created by Chan on 8/30/24.
//

import UIKit
import Photos

struct MediaItem: Equatable {
    let asset: PHAsset?
    let image: UIImage?
    let videoURL: URL?
    let creationDate: Date?
    let location: CLLocation?
    let pixelWidth: Int
    let pixelHeight: Int
    let mediaType: PHAssetMediaType
    let duration: Double?
    let fileSize: Int64?
}
