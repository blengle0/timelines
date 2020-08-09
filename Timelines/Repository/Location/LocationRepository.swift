//
//  LocationRepository.swift
//  Timelines
//
//  Created by Bryan Lengle on 2020-08-08.
//  Copyright © 2020 Bryan Lengle. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

protocol LocationRepositoryType {
    var hasLocationAccessPublisher: Published<Bool>.Publisher { get }
    var locationPublisher: Published<CLLocation?>.Publisher { get }
    func requestAuthorization()
    func requestUpdatedLocation()
}

class LocationRepository: NSObject {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentAuthorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var hasLocationAccess: Bool = false
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.delegate = self
    }
    
}

extension LocationRepository: LocationRepositoryType {
    
    var hasLocationAccessPublisher: Published<Bool>.Publisher { $hasLocationAccess }
    var locationPublisher: Published<CLLocation?>.Publisher { $location }
    
    func requestAuthorization() {
        if currentAuthorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        else if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl, completionHandler:nil)
        }
    }
    
    func requestUpdatedLocation() {
        if hasLocationAccess {
            locationManager.startUpdatingLocation()
        }
    }
}

extension LocationRepository: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if currentAuthorizationStatus != status {
            currentAuthorizationStatus = status
            hasLocationAccess = status == .authorizedAlways || status == .authorizedWhenInUse
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latestLocation = locations.last {
            location = latestLocation
        }
    }
    
}
