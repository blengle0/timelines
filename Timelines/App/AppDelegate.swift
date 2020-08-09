//
//  AppDelegate.swift
//  Timelines
//
//  Created by Bryan Lengle on 2020-08-08.
//  Copyright © 2020 Bryan Lengle. All rights reserved.
//

import UIKit
import Combine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var repository: RepositoryManagerType? {
        return AppConfiguration.repositoryManager
    }
    private var cancellables: Set<AnyCancellable> = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        AppConfiguration.configureRepository()
        
        repository?.locationRepositoryType.locationPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] (location) in
                if let location = location {
                    self?.repository?.timelinesRepository.addLocationWith(long: location.coordinate.longitude, lat: location.coordinate.latitude)
                }
            }).store(in: &cancellables)
        
        repository?.locationRepositoryType.hasLocationAccessPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] (hasLocationAccess) in
                self?.repository?.locationRepositoryType.requestUpdatedLocation()
            }).store(in: &cancellables)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

