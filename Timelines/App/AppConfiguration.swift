//
//  AppConfiguration.swift
//  Timelines
//
//  Created by Bryan Lengle on 2020-08-08.
//  Copyright © 2020 Bryan Lengle. All rights reserved.
//

import Foundation

class AppConfiguration: NSObject {
    
    static var repositoryManager: RepositoryManagerType?
    
    static func configureRepository() {
        repositoryManager = RepositoryManager()
    }
    
}
