//
//  MetaDataViewController.swift
//  iOSPhotos
//
//  Created by Chan on 8/29/24.
//

import UIKit

final class MetaDataViewController: UIViewController {
    private let image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // 메타데이터 표시 로직 추가
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        // 메타데이터 표시를 위한 UI 구성
    }
}
