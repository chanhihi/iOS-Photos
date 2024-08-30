//
//  SegmentedControl.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

class SegmentedControl: UISegmentedControl {
    weak var delegate: SegmentedControlDelegate?
    
    init(items: [String]) {
        super.init(items: items)
        self.setupSegmentedControl()
        self.setupUI()
        self.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .systemBackground
        self.selectedSegmentTintColor = .systemGray
    }
    
    private func setupSegmentedControl() {
        let savedIndex = AppStateManager.shared.loadLastStorageSegmentedIndex()
        self.selectedSegmentIndex = (SegmentedModel.SortType.year.rawValue...SegmentedModel.SortType.all.rawValue).contains(savedIndex) ? savedIndex : 3
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        delegate?.segmentedControlDidChange(self, selectedSegmentIndex: self.selectedSegmentIndex)
    }
}
