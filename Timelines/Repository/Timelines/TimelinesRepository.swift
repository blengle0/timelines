//
//  TimelinesRepository.swift
//  Timelines
//
//  Created by Bryan Lengle on 2020-08-08.
//  Copyright © 2020 Bryan Lengle. All rights reserved.
//

import UIKit
import Foundation
import CoreData

enum TimelinesFilterType: Int {
    case latest
    case today
    case yesterday
    case all
}

extension Notification.Name {
    static let TimelinesDidUpdate = Notification.Name(rawValue: "TimelinesDidUpdate")
}

protocol TimelinesRepositoryType {
    func addLocationWith(long: Double, lat: Double)
    func getLocations(filter: TimelinesFilterType) -> [TimelineLocation]
}

class TimelinesRepository: CoreDataRepository {
    
    typealias EntityType = TimelineLocation
    
    lazy var persistentContainer: NSPersistentContainer = {
        return createPersistentContainer()
    }()
    
    var dataModelName: String {
        return "Timelines"
    }
    
}

extension TimelinesRepository: TimelinesRepositoryType {
    
    func addLocationWith(long: Double, lat: Double) {
        let entity = createEntity()
        entity.long = long
        entity.lat = lat
        entity.timestamp = Date()
        saveContext()
        NotificationCenter.default.post(name: .TimelinesDidUpdate, object: self)
    }
    
    func getLocations(filter: TimelinesFilterType) -> [TimelineLocation] {
        let today = Date()
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: today)
        var dateComponents = DateComponents()
        dateComponents.setValue(-1, for: .day)
        let startOfYesterday = calendar.date(byAdding: dateComponents, to: startOfToday) ?? startOfToday
        
        var predicate: NSPredicate? = nil
        let sortDescriptors: [NSSortDescriptor]? = [NSSortDescriptor(key: "timestamp", ascending: false)]
        var fetchLimit: Int = 0
        
        switch filter {
        case .latest:
            fetchLimit = 1
        case .today:
            predicate = NSPredicate(format: "(timestamp >= %@)", argumentArray: [startOfToday])
        case .yesterday:
            predicate = NSPredicate(format: "(timestamp >= %@) AND (timestamp < %@)", argumentArray: [startOfYesterday, startOfToday])
        case .all:
            break
        }
        
        return getAllEntitiesWith(predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit)
    }
    
}
