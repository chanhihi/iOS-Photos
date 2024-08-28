//
//  SearchController.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

class SearchController: UISearchController, UISearchResultsUpdating {
    override init(searchResultsController: UIViewController? = nil) {
        super.init(searchResultsController: searchResultsController)
        self.setupSearchController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSearchController() {
        self.searchResultsUpdater = self
        self.obscuresBackgroundDuringPresentation = false
        self.searchBar.placeholder = "Search Photos"
        self.definesPresentationContext = true
    }

    func updateSearchResults(for searchController: UISearchController) {
        // 필터링 로직을 여기에 구현합니다.
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return
        }
        // 검색 결과를 업데이트하는 로직을 구현
    }
}
