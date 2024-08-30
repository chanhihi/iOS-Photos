//
//  ForYouViewController.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

class ForYouViewController: UIViewController {

    var viewModel: ForYouViewModel!
    private var images: [UIImage] = []
    private var importCollectionView: ForYouCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkPermissionsAndLoadPhotos()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        // CollectionView 레이아웃 설정
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        // CollectionView 생성
        importCollectionView = ForYouCollectionView(viewModel: self.viewModel)
        
        // CollectionView 추가
        view.addSubview(importCollectionView)

        // 제약조건 설정
        importCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            importCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            importCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            importCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            importCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func checkPermissionsAndLoadPhotos() {
        
    }

    private func loadPhotos() {
        
    }

    private func showPermissionAlert() {
        // 권한이 없을 때 경고 메시지
        let alert = UIAlertController(title: "Permission Denied", message: "Please allow photo library access in settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension ForYouViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
        let imageView = UIImageView(image: images[indexPath.item])
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = cell.contentView.bounds
        cell.contentView.addSubview(imageView)
        return cell
    }
}
