//
//  CoordinatorFinishDelegate.swift
//  iOSPhotos
//
//  Created by Chan on 8/30/24.
//

import Foundation

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
