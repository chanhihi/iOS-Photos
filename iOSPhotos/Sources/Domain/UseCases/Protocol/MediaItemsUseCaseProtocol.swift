//
//  MediaItemsUseCaseProtocol.swift
//  iOSPhotos
//
//  Created by Chan on 8/30/24.
//

import UIKit

protocol MediaItemsUseCaseProtocol {
    func execute(completion: @escaping ([MediaItem]) -> Void)
}
