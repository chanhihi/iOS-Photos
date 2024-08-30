//
//  StorageViewController.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit
import Combine

final class StorageViewController: UIViewController {
    
    var viewModel: StorageViewModel!
    private var segmentedControl: SegmentedControl!
    private var storageCollectionView: StorageCollectionView!
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupSegmentedControl()
        setupLayout()
        setupLayerBinding()
        setupPhotosBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupCollectionView() {
        storageCollectionView = StorageCollectionView(viewModel: self.viewModel)
        view.addSubview(storageCollectionView)
    }
    
    private func setupSegmentedControl() {
        segmentedControl = SegmentedControl(items: SegmentedModel().items)
        segmentedControl.delegate = self
        view.addSubview(segmentedControl)
    }
    
    private func setupPhotosBinding() {
        viewModel.$mediaItems
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] mediaItems in
                self?.storageCollectionView.setMediaItems(mediaItems)
            })
            .store(in: &cancellables)
    }
    
    private func setupLayerBinding() {
        viewModel.$currentLayout
            .receive(on: DispatchQueue.main)
            .sink { [weak self] layout in
                self?.storageCollectionView.updateLayout(layout)
            }
            .store(in: &cancellables)
    }
    
    private func setupLayout() {
        let insets = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10)
        let betweenDistance: CGFloat = 20
        
        storageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            storageCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            storageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: storageCollectionView.bottomAnchor, constant: betweenDistance),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right),
            segmentedControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: insets.bottom)
        ])
    }
}

extension StorageViewController: SegmentedControlDelegate {
    func segmentedControlDidChange(_ segmentedControl: SegmentedControl,
                                   selectedSegmentIndex: Int) {
        guard let sortType = SegmentedModel.SortType(rawValue: selectedSegmentIndex)
        else { return }
        AppStateManager.shared.saveLastStorageSegmentedIndex(selectedSegmentIndex)
        viewModel.updateLayout(for: sortType)
    }
}
