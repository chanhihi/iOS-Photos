//
//  SegmentedControlDelegate.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

protocol SegmentedControlDelegate: AnyObject {
    func segmentedControlDidChange(_ segmentedControl: SegmentedControl, selectedSegmentIndex: Int)
}
