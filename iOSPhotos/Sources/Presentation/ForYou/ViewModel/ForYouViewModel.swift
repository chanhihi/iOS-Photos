//
//  ForYouViewModel.swift
//  iOSPhotos
//
//  Created by Chan on 8/29/24.
//

import Foundation

final class ForYouViewModel {
    weak var coordinator: ForYouCoordinator?
    
    init(_ coordinator: ForYouCoordinator) {
        self.coordinator = coordinator
    }
}
