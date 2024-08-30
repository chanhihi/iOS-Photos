//
//  FullScreenContentViewController.swift
//  iOSPhotos
//
//  Created by Chan on 8/29/24.
//

import UIKit
import AVKit

final class FullScreenContentViewController: UIViewController {
    var coordinator: FullScreenContentCoordinator?
    private var mediaItems: [MediaItem]
    private var currentIndex: Int
    private let collectionView: UICollectionView
    let toolbar = UIToolbar()
    
    init(mediaItems: [MediaItem], startIndex: Int = 0) {
        self.mediaItems = mediaItems
        self.currentIndex = startIndex
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        
        super.init(nibName: nil, bundle: nil)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MediaItemCell.self, forCellWithReuseIdentifier: MediaItemCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupCollectionView()
        setupBottomToolbar()
        setupLayout()
        scrollToCurrentIndex(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.isNavigationBarHidden = true
        self.coordinator?.finish()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationBar() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(dismissViewController))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    
    private func setupBottomToolbar() {
        view.addSubview(toolbar)
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareContent))
        let likeButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeContent))
        let metaDataButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(showImageMetaData))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteCurrentItem))
        
        toolbar.items = [shareButton, UIBarButtonItem.flexibleSpace(), likeButton, UIBarButtonItem.flexibleSpace(), metaDataButton, UIBarButtonItem.flexibleSpace(), deleteButton]
    }
    
    private func setupLayout() {
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc private func dismissViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func showImageMetaData() {
        guard mediaItems[currentIndex].mediaType == .image else { return }
        let metaDataViewController = MetaDataViewController(image: mediaItems[currentIndex].image!)
        navigationController?.pushViewController(metaDataViewController, animated: true)
    }
    
    @objc private func deleteCurrentItem() {
        guard !mediaItems.isEmpty else { return }
        mediaItems.remove(at: currentIndex)

        if mediaItems.isEmpty {
            dismissViewController()
        } else {
            currentIndex = max(0, currentIndex - 1)
            collectionView.reloadData()
            scrollToCurrentIndex(animated: true)
        }
    }
    
    @objc private func shareContent() {
        // 공유 기능 구현
    }
    
    @objc private func likeContent() {
        // 좋아요 기능 구현
    }
    
    private func scrollToCurrentIndex(animated: Bool) {
        collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: animated)
    }
}

// MARK: - UICollectionViewDataSource
extension FullScreenContentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaItemCell.reuseIdentifier, for: indexPath) as! MediaItemCell
        cell.configure(with: mediaItems[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FullScreenContentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let visibleIndexPath = collectionView.indexPathsForVisibleItems.first else { return }
        currentIndex = visibleIndexPath.item
    }
}

// MARK: - UICollectionViewDelegate
extension FullScreenContentViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        if let indexPath = collectionView.indexPathForItem(at: visiblePoint) {
            currentIndex = indexPath.item
        }
    }
}

// MARK: - MediaItemCell Class
final class MediaItemCell: UICollectionViewCell {
    static let reuseIdentifier = "MediaItemCell"
    private let imageView = UIImageView()
    private var playerViewController: AVPlayerViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(with mediaItem: MediaItem) {
        switch mediaItem.mediaType {
        case .image:
            imageView.image = mediaItem.image
            playerViewController?.view.removeFromSuperview()
            playerViewController = nil
        case .video:
            if let videoURL = mediaItem.videoURL {
                playerViewController = AVPlayerViewController()
                let player = AVPlayer(url: videoURL)
                playerViewController?.player = player
                playerViewController?.view.frame = contentView.bounds
                if let playerView = playerViewController?.view {
                    contentView.addSubview(playerView)
                }
            }
        default:
            break
        }
    }
}
