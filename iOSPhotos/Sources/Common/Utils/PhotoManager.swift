//
//  PhotoManager.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit
import Photos

class PhotoManager {
    var images: [UIImage] = []
    
    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        default:
            completion(false)
        }
    }
    
    func loadPhotos(completion: @escaping ([UIImage]) -> Void) {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let allPhotos = PHAsset.fetchAssets(with: .image, options: allPhotosOptions)
        
        var fetchedImages: [UIImage] = []
        let imageManager = PHCachingImageManager()
        
        allPhotos.enumerateObjects { (asset, _, _) in
            let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = true
            
            imageManager.requestImage(for: asset,
                                      targetSize: imageSize,
                                      contentMode: .aspectFill,
                                      options: options) { (image, _) in
                if let image = image {
                    fetchedImages.append(image)
                }
            }
        }
        
        DispatchQueue.main.async {
            completion(fetchedImages)
        }
    }
}
