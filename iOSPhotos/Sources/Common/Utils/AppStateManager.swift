//
//  AppStateManager.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import Foundation

class AppStateManager {
    static let shared = AppStateManager()
    
    private let lastTabIndexKey = "lastTabIndex"
    private let lastStorageSegmentedIndexKey = "lastStorageSegmentedIndex"

    func saveLastTabIndex(_ index: Int) {
        UserDefaults.standard.set(index, forKey: lastTabIndexKey)
        UserDefaults.standard.synchronize()
    }

    func loadLastTabIndex() -> Int {
        return UserDefaults.standard.integer(forKey: lastTabIndexKey)
    }
    
    func saveLastStorageSegmentedIndex(_ index: Int) {
        UserDefaults.standard.set(index, forKey: lastStorageSegmentedIndexKey)
        UserDefaults.standard.synchronize()
    }

    func loadLastStorageSegmentedIndex() -> Int {
        return UserDefaults.standard.integer(forKey: lastStorageSegmentedIndexKey)
    }
}
