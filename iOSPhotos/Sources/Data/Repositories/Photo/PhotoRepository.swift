
//
//  PhotoRepository.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit
import Photos

class PhotoRepository {
    func fetchAssets(completion: @escaping ([PHAsset]) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        DispatchQueue.main.async {
            completion(assets.objects(at: IndexSet(0..<assets.count)))
        }
    }
    
    func loadImages(from assets: [PHAsset], completion: @escaping ([UIImage]) -> Void) {
        let imageManager = PHCachingImageManager()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        
        var images: [UIImage] = []
        let group = DispatchGroup()
        
        for asset in assets {
            group.enter()
            let targetSize = CGSize(width: 200, height: 200)
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { (image, _) in
                DispatchQueue.main.async {
                    if let image = image {
                        images.append(image)
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
    
}
