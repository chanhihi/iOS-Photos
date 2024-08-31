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
    private let toolbar = UIToolbar()
    
    init(viewModel: FullScreenContentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupUI()
        setupBottomToolbar()
        setupLayout()
        setupCollectionView()
        setupContentIndexBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        self.coordinator?.finish()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationBar() {
        guard let navigationController = navigationController else { return }

        navigationController.isNavigationBarHidden = false
        navigationController.navigationBar.isTranslucent = false
        tabBarController?.tabBar.isHidden = true
        navigationItem.largeTitleDisplayMode = .never

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray2
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.navigationBar.tintColor = .white
        
//        navigationController.navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)

        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(dismissViewController))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupBottomToolbar() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareContent))
        let likeButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeContent))
        let metaDataButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(showImageMetaData))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteCurrentItem))
        
        toolbar.items = [
            shareButton,
            UIBarButtonItem.flexibleSpace(),
            likeButton,
            UIBarButtonItem.flexibleSpace(),
            metaDataButton,
            UIBarButtonItem.flexibleSpace(),
            deleteButton
        ]
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
            toolbar.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
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
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func updateNavigationBarTitle(at index: Int) {
        navigationItem.title = "Item \(index + 1) / \(viewModel.mediaItems.count)"
    }
    
    @objc private func dismissViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func showImageMetaData() {
        viewModel.showMetaData()
    }
    
    @objc private func deleteCurrentItem() {
        viewModel.deleteCurrentItem()
    }
    
    @objc private func shareContent() {
        // 공유 기능 구현
    }
    
    @objc private func likeContent() {
        // 좋아요 기능 구현
    }
}
