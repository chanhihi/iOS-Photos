//
//  TabBarItemType.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

enum TabBarItemType: Int, CaseIterable {
    case storage, foryou, album, search
    
    var title: String {
        switch self {
        case .storage: return NSLocalizedString("보관함", comment: "Tab title for Storage")
        case .foryou: return NSLocalizedString("사진 관리", comment: "Tab title for Import")
        case .album: return NSLocalizedString("앨범", comment: "Tab title for Albums")
        case .search: return NSLocalizedString("검색", comment: "Tab title for Search")
        }
    }
    
    var iconName: String {
        switch self {
        case .storage: return "photo.on.rectangle"
        case .foryou: return "heart.text.square"
        case .album: return "square.stack.fill"
        case .search: return "magnifyingglass"
        }
    }
    
}
