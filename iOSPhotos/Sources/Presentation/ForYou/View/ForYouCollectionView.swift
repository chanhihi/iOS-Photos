//
//  ForYouCollectionView.swift
//  iOSPhotos
//
//  Created by Chan on 8/29/24.
//

import UIKit

final class ForYouCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var mediaItems: [UIImage] = []
    private var viewModel: ForYouViewModel?
    
    init(layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout(), viewModel: ForYouViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero, collectionViewLayout: layout)
        setupProperty()
        setupUI()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProperty() {
        self.delegate = self
        self.dataSource = self
        self.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func setupUI() {
        self.backgroundColor = .secondarySystemBackground
        self.alwaysBounceVertical = true  // 사용자 경험 향상
        setupDefaultLayout()  // 기본 레이아웃 설정
    }
    
    private func setupBindings() {
        // ViewModel의 변경 사항에 따른 데이터 바인딩 설정 (예: 사진 데이터가 변경될 때)
//        viewModel?.onPhotosUpdate = { [weak self] photos in
//            self?.setPhotos(photos)
//        }
    }
    
    private func setupDefaultLayout() {
        // Segmented Control의 3번과 동일한 동작으로 설정
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .allSize  // 모든 이미지가 동일한 크기로 설정됨
        layout.sectionInset = .allEdgeInset
        self.collectionViewLayout = layout
    }
    
    func setPhotos(_ photos: [UIImage]) {
        self.mediaItems = photos
        self.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        configureCell(cell, with: mediaItems[indexPath.row])
        return cell
    }
    
    private func configureCell(_ cell: CustomCollectionViewCell, with image: UIImage) {
//        cell.configure(with: image)
        cell.layer.cornerRadius = .collectionViewCornerRadiusDayAll  // 고정된 코너 반경
        cell.clipsToBounds = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = mediaItems[indexPath.row]
        
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell else {
            return
        }
        
//        viewModel?.didSelectImage(selectedImage, from: selectedCell.imageView)  // 선택된 이미지 처리
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Methods
extension ForYouCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .collectionViewMinimumInterSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .collectionViewMinimumLineSpacing
    }
}
