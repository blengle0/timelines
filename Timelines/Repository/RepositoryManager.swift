//
//  RepositoryManager.swift
//  Timelines
//
//  Created by Bryan Lengle on 2020-08-08.
//  Copyright © 2020 Bryan Lengle. All rights reserved.
//

import Foundation

protocol RepositoryManagerType {
    var timelinesRepository: TimelinesRepositoryType { get }
    var locationRepositoryType: LocationRepositoryType { get }
}

class RepositoryManager: RepositoryManagerType {
    
    lazy var timelinesRepository: TimelinesRepositoryType = {
        return TimelinesRepository()
    }()
    
    lazy var locationRepositoryType: LocationRepositoryType = {
        return LocationRepository()
    }()
    
}
