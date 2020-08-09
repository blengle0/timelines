//
//  TimelineLocation+CoreDataProperties.swift
//  Timelines
//
//  Created by Bryan Lengle on 2020-08-08.
//  Copyright © 2020 Bryan Lengle. All rights reserved.
//
//

import Foundation
import CoreData


extension TimelineLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimelineLocation> {
        return NSFetchRequest<TimelineLocation>(entityName: "TimelineLocation")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double

}
