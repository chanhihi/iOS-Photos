//
//  SegmentedModel.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

struct SegmentedModel {
    let items = ["연", "월", "일", "모든 사진"]
    
    enum SortType: Int {
        case year = 0, month, day, all
    }
}
