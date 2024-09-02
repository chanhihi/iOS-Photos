//
//  PhotoManager.swift
//  iOSPhotos
//
//  Created by Chan on 8/30/24.
//

import UIKit
import Photos
import AVFoundation

final class MediaItemsLibraryDataSource {
    
    func checkAndRequestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized)
                }
            }
        default:
            completion(false)
        }
    }
    
    func loadContents(completion: @escaping ([MediaItem]) -> Void) {
        checkAndRequestPhotoLibraryPermission { [weak self] isAuthorized in
            guard isAuthorized else {
                print("사진 라이브러리 권한이 없습니다.")
                completion([])
                return
            }
            
            guard let self = self else { return }
            
            let allAssetsOptions = PHFetchOptions()
            allAssetsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            let allAssets = PHAsset.fetchAssets(with: allAssetsOptions)
            
            var fetchedMediaItems: [MediaItem] = []
            let imageManager = PHCachingImageManager()
            
            allAssets.enumerateObjects { (asset, _, _) in
                let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                let options = PHImageRequestOptions()
                options.deliveryMode = .highQualityFormat
                options.isSynchronous = true
                
                switch asset.mediaType {
                case .image:
                    imageManager.requestImage(for: asset,
                                              targetSize: imageSize,
                                              contentMode: .aspectFill,
                                              options: options) { (image, _) in
                        if let image = image {
                            let photo = MediaItem(
                                image: image,
                                videoURL: nil,
                                creationDate: asset.creationDate,
                                location: asset.location,
                                pixelWidth: asset.pixelWidth,
                                pixelHeight: asset.pixelHeight,
                                mediaType: .image,
                                duration: nil,
                                fileSize: nil
                            )
                            fetchedMediaItems.append(photo)
                        }
                    }
                case .video:
                    imageManager.requestAVAsset(forVideo: asset, options: nil) { (avAsset, _, _) in
                        if let urlAsset = avAsset as? AVURLAsset {
                            let thumbnailOptions = PHImageRequestOptions()
                            thumbnailOptions.deliveryMode = .highQualityFormat
                            thumbnailOptions.isSynchronous = true
                            
                            imageManager.requestImage(for: asset,
                                                      targetSize: imageSize,
                                                      contentMode: .aspectFill,
                                                      options: thumbnailOptions) { (image, _) in
                                
                                let duration = CMTimeGetSeconds(urlAsset.duration)
                                let fileSize = self.getFileSize(url: urlAsset.url)
                                
                                let video = MediaItem(
                                    image: image,
                                    videoURL: urlAsset.url,
                                    creationDate: asset.creationDate,
                                    location: asset.location,
                                    pixelWidth: asset.pixelWidth,
                                    pixelHeight: asset.pixelHeight,
                                    mediaType: .video,
                                    duration: duration,
                                    fileSize: fileSize
                                )
                                fetchedMediaItems.append(video)
                            }
                        }
                    }
                default:
                    break
                }
            }
            
            DispatchQueue.main.async {
                completion(fetchedMediaItems)
            }
        }
    }
    
    private func getFileSize(url: URL) -> Int64? {
        do {
            let resources = try url.resourceValues(forKeys: [.fileSizeKey])
            return resources.fileSize.map { Int64($0) }
        } catch {
            print("Error retrieving file size for URL: \(url) - \(error)")
            return nil
        }
    }
}
