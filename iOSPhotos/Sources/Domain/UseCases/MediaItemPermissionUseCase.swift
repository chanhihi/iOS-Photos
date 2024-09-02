//
//  MediaItemPermissionUseCase.swift
//  iOSPhotos
//
//  Created by Chan on 9/2/24.
//

import Photos

class MediaItemPermissionUseCase {
    
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
}
