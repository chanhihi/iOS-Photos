//
//  SearchModel.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

struct Moment {
    let title: String
    let images: [UIImage]
}

struct Person {
    let name: String
    let photo: UIImage
}

struct Category {
    let name: String
    let items: [String]
}

enum SearchSection {
    case specialMoments([Moment])
    case people([Person])
    case categoryGroups([Category])
    case recentSearches([String])
}
