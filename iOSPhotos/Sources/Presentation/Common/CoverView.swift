//
//  CoverView.swift
//  iOSPhotos
//
//  Created by Chan on 8/29/24.
//

import UIKit

final class CoverView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS Photos KCH"
        label.textAlignment = .center
        label.font = UIFontMetrics(forTextStyle: .title1)
            .scaledFont(for: UIFont.systemFont(ofSize: 36, weight: .bold))
        label.textColor = .systemGray
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .systemBackground
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
