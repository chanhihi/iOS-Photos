//
//  SegmentedControl.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit
import Combine

final class SegmentedControl: UISegmentedControl {
    private var viewModel: StorageViewModel
    
    init(items: [String], viewModel: StorageViewModel) {
        self.viewModel = viewModel
        super.init(items: items)
        self.setupSegmentedControl()
        self.setupUI()
        self.setupBinding()
        self.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .systemBackground
        self.selectedSegmentTintColor = .systemGray
    }
    
    private func setupBinding() {
        viewModel.$selectedSegmentIndex
            .receive(on: RunLoop.main)
            .sink { [weak self] index in
                self?.updateSegmentIndex(index)
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func setupSegmentedControl() {
        let savedIndex = AppStateManager.shared.loadLastStorageSegmentedIndex()
        self.selectedSegmentIndex = (SegmentedModel.SortType.year.rawValue...SegmentedModel.SortType.all.rawValue).contains(savedIndex) ? savedIndex : SegmentedModel.SortType.all.rawValue
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        viewModel.updateSegmentIndex(to: self.selectedSegmentIndex)
    }
    
    func updateSegmentIndex(_ index: Int) {
        if self.selectedSegmentIndex != index {
            self.selectedSegmentIndex = index
        }
    }
    
}
