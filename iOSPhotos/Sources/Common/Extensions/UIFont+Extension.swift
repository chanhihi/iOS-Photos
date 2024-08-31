//
//  UIFont+Extension.swift
//  iOSPhotos
//
//  Created by Chan on 9/1/24.
//

import UIKit

extension UIFont {
    static func boldPreferredFont(forTextStyle style: UIFont.TextStyle) -> UIFont {
        let font = UIFont.preferredFont(forTextStyle: style)
        guard let descriptor = font.fontDescriptor.withSymbolicTraits(.traitBold) else {
            return font
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
