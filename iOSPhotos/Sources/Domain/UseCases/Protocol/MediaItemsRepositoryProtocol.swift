//
//  MediaItemsRepositoryProtocol.swift
//  iOSPhotos
//
//  Created by Chan on 8/30/24.
//

protocol MediaItemsRepositoryProtocol {
    func loadMediaItems(completion: @escaping ([MediaItem]) -> Void)
}
