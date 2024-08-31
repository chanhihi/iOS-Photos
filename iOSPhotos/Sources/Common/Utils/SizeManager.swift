//
//  SizeManager.swift
//  iOSPhotos
//
//  Created by Chan on 8/28/24.
//

import UIKit

typealias WH = (width: CGFloat, height: CGFloat)

final class SizeManager {
    static let shared = SizeManager()
    
    private init() {
        updateSizes()
    }
    
    func updateSizes() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let squareDay = screenWidth * 0.322
        let squareAll = screenWidth * 0.188
        
        let year: WH = (width: screenWidth * 0.9, height: screenHeight * 0.33)
        let month: WH = (width: screenWidth * 0.9, height: screenHeight * 0.25)
        let day: WH = (width: squareDay, height: squareDay)
        let all: WH = (width: squareAll, height: squareAll)
        
        CGSize.yearSize = CGSize(width: year.width, height: year.height)
        CGSize.monthSize = CGSize(width: month.width, height: month.height)
        CGSize.daySize = CGSize(width: day.width, height: day.height)
        CGSize.allSize = CGSize(width: all.width, height: all.height)
    }
}
