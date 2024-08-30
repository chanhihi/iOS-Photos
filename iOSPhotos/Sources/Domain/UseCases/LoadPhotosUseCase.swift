//
//  LoadPhotosUseCase.swift
//  iOSPhotos
//
//  Created by Chan on 8/30/24.
//

final class LoadPhotosUseCase: MediaItemsUseCaseProtocol {
    private let repository: MediaItemsRepositoryProtocol
    
    init(repository: MediaItemsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(completion: @escaping ([MediaItem]) -> Void) {
        repository.loadMediaItems(completion: completion)
    }
}
