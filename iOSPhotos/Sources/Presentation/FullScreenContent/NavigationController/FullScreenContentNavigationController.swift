//
//  FullScreenContentNavigationController.swift
//  iOSPhotos
//
//  Created by Chan on 9/1/24.
//

import UIKit

class FullScreenContentNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.setupNavigationController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNavigationController()
    }
    
    private func setupNavigationController() {
        self.isNavigationBarHidden = false
        self.navigationBar.isTranslucent = true
        self.navigationItem.largeTitleDisplayMode = .never
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray5
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBackground]
        
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.prefersLargeTitles = false
    }
}
