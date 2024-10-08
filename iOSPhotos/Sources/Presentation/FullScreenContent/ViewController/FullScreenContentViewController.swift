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
    private var viewModel: FullScreenContentViewModel
    private var collectionView: MediaCollectionView?
    private var toolbar: UIToolbar!
    
    var finalImageViewFrame: CGRect?
    
    init(viewModel: FullScreenContentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupCollectionView()
        setupUI()
        setupContentIndexBinding()
        setupToolbar()
        setupLayout()
        setupBackgroundBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustTabBarVisibility(hide: true)
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.toolbar.removeFromSuperview()
        adjustTabBarVisibility(hide: false)
        self.coordinator?.finish()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let collectionViewCell = collectionView?.visibleCells.first as? MediaItemCell {
            finalImageViewFrame = collectionViewCell.imageView.frame
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func setupBackgroundBinding() {
        viewModel.$viewControllerBackgroundColorAlpha
            .receive(on: RunLoop.main)
            .sink { [weak self] newAlpha in
                self?.view.backgroundColor = self?.view.backgroundColor?.withAlphaComponent(newAlpha)
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(dismissViewController))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupToolbar() {
        toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: SizeManager.shared.screenWidth, height: 49))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareContent))
        let likeButton = UIBarButtonItem(image: UIImage(systemName: viewModel.isLikedCurrentItem() ? "heart.fill" : "heart"), style: .plain, target: self, action: #selector(likeContent))
        let metaDataButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(showImageMetaData))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteCurrentItem))
        
        let flexItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [
            shareButton,
            flexItem,
            likeButton,
            flexItem,
            metaDataButton,
            flexItem,
            deleteButton
        ]
        
    }
    
    private func adjustTabBarVisibility(hide: Bool) {
        guard let tabBarController = self.tabBarController else { return }
        tabBarController.tabBar.isHidden = hide
    }
    
    private func setupLayout() {
        guard let collectionView = collectionView else { return }
        
        self.navigationController?.view = view
        
        view.addSubview(toolbar)
        view.addSubview(collectionView)
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 49),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView = MediaCollectionView(frame: .zero, collectionViewLayout: layout, viewModel: viewModel)
    }
    
    private func setupContentIndexBinding() {
        viewModel.$currentIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                self?.updateNavigationBarTitle(at: index)
                self?.updateCurrentItemLikeButton()
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func updateNavigationBarTitle(at index: Int) {
        guard !viewModel.mediaItemsStore.mediaItems.isEmpty, index >= 0, index < viewModel.mediaItemsStore.mediaItems.count else {
            navigationItem.title = "No Media Available"
            navigationItem.titleView = nil
            return
        }
        
        let item = viewModel.mediaItemsStore.mediaItems[index]
        navigationItem.title = formatDate(item.creationDate)
        
        if let creationDate = item.creationDate {
            let dateOnlyFormatter = DateFormatter()
            dateOnlyFormatter.dateFormat = "yyyy년 MM월 dd일"
            let dateOnlyString = dateOnlyFormatter.string(from: creationDate)
            
            let timeOnlyFormatter = DateFormatter()
            timeOnlyFormatter.dateFormat = "a h:mm"
            let timeOnlyString = timeOnlyFormatter.string(from: creationDate)
            
            setNavigationBarTitleAndSubtitle(title: dateOnlyString, subtitle: timeOnlyString)
        }
    }
    
    private func setNavigationBarTitleAndSubtitle(title: String, subtitle: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .semiboldPreferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .gray
        subtitleLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        
        navigationItem.titleView = stackView
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Date Unknown" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
    
    @objc private func dismissViewController() {
        viewModel.dismissViewController()
    }
    
    @objc private func showImageMetaData() {
        let metadataInfo = viewModel.getMetaDataInfo()
        let metadataVC = MetadataViewController(metadataInfo: metadataInfo)
        metadataVC.modalPresentationStyle = .custom
        metadataVC.transitioningDelegate = self
        present(metadataVC, animated: true, completion: nil)
    }
    
    @objc private func deleteCurrentItem() {
        let alertController = UIAlertController(title: "사진 삭제", message: "이 사진을 삭제하시겠습니까?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.performDeletion()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func performDeletion() {
        viewModel.deleteCurrentItem()
    }
    
    @objc private func shareContent() {
        let item = viewModel.mediaItemsStore.mediaItems[viewModel.currentIndex]
        let itemsToShare: [Any] = [item.image as Any]
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func likeContent() {
        if let isLiked = viewModel.likeContent() {
            updateLikeButtonImage(isLiked: isLiked)
        }
    }
    
    private func updateLikeButtonImage(isLiked: Bool) {
        let imageName = isLiked ? "heart.fill" : "heart"
        let likeButton = UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: #selector(likeContent))
        toolbar.items?[2] = likeButton
    }
    
    private func updateCurrentItemLikeButton() {
        let imageName = viewModel.isLikedCurrentItem() ? "heart.fill" : "heart"
        let likeButton = UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: #selector(likeContent))
        toolbar.items?[2] = likeButton
    }
    
}

extension FullScreenContentViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return oneThirdSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
