//
//  MediaLoader.swift
//  iOSPhotos
//
//  Created by Chan on 9/2/24.
//

import Photos

final class MediaLoader {
    private let imageManager = PHCachingImageManager()
    private var allAssets: PHFetchResult<PHAsset>?
    var currentPage: Int = 0
    private let itemsPerPage: Int = 60
    
    func checkAndRequestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized, .limited:
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
            self.allAssets = PHAsset.fetchAssets(with: allAssetsOptions)
            
            self.loadPage(completion: completion)
        }
    }
    
    func loadPage(completion: @escaping ([MediaItem]) -> Void) {
        guard let allAssets = allAssets else {
            completion([])
            return
        }
        
        let startIndex = currentPage * itemsPerPage
        guard startIndex < allAssets.count else {
            completion([])
            return
        }
        
        let endIndex = min(startIndex + itemsPerPage, allAssets.count)
        let assetsToLoad = allAssets.objects(at: IndexSet(integersIn: startIndex..<endIndex))
        
        var fetchedMediaItems: [MediaItem] = []
        let group = DispatchGroup()
        
        for asset in assetsToLoad {
            group.enter()
            loadMediaItem(for: asset) { mediaItem in
                if let mediaItem = mediaItem {
                    fetchedMediaItems.append(mediaItem)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(fetchedMediaItems)
        }
    }
    
    private func loadMediaItem(for asset: PHAsset, completion: @escaping (MediaItem?) -> Void) {
        let imageSize = CGSize(width: 150, height: 150)
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        
        if asset.mediaType == .image {
            imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options) { (image, _) in
                if let image = image {
                    let photo = MediaItem(
                        asset: asset,
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
                    completion(photo)
                } else {
                    completion(nil)
                }
            }
        } else if asset.mediaType == .video {
            imageManager.requestAVAsset(forVideo: asset, options: nil) { (avAsset, _, _) in
                guard let urlAsset = avAsset as? AVURLAsset else {
                    completion(nil)
                    return
                }
                
                self.imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options) { (image, _) in
                    if let image = image {
                        let duration = CMTimeGetSeconds(urlAsset.duration)
                        let fileSize = self.getFileSize(url: urlAsset.url)
                        
                        let video = MediaItem(
                            asset: asset,
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
                        completion(video)
                    } else {
                        completion(nil)
                    }
                }
            }
        } else {
            completion(nil)
        }
    }
    
    private func getFileSize(url: URL) -> Int64? {
        do {
            let resources = try url.resourceValues(forKeys: [.fileSizeKey])
            return resources.fileSize.map { Int64($0) }
        } catch {
            print("Error retrieving file size: \(error.localizedDescription)")
            return nil
        }
    }
}
