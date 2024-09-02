//
//  MetadataViewController.swift
//  iOSPhotos
//
//  Created by Chan on 9/2/24.
//

import UIKit

final class MetadataViewController: UIViewController {

    private let metadataLabel = UILabel()
    
    init(metadataInfo: String) {
        super.init(nibName: nil, bundle: nil)
        self.metadataLabel.text = metadataInfo
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        metadataLabel.numberOfLines = 0
        metadataLabel.textAlignment = .center
        metadataLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(metadataLabel)
        
        NSLayoutConstraint.activate([
            metadataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            metadataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            metadataLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
