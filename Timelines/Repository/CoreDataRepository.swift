//
//  CoreDataRepository.swift
//  Timelines
//
//  Created by Bryan Lengle on 2020-08-08.
//  Copyright © 2020 Bryan Lengle. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataRepository {
    
    associatedtype EntityType: NSManagedObject
    var dataModelName: String { get }
    var persistentContainer: NSPersistentContainer { get }
    
    func createPersistentContainer() -> NSPersistentContainer
    func saveContext()
    func getAllEntitiesWith(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int) -> [EntityType]
    func getAllEntities() -> [EntityType]
    func createEntity() -> EntityType
    
}

extension CoreDataRepository {
    
    func createPersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: dataModelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getAllEntitiesWith(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int) -> [EntityType] {
        let context = persistentContainer.viewContext
        let entityFetch = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: EntityType.self))
        entityFetch.predicate = predicate
        entityFetch.sortDescriptors = sortDescriptors
        entityFetch.fetchLimit = fetchLimit
        
        do {
            let fetchedEntities = try context.fetch(entityFetch) as! [EntityType]
            return fetchedEntities
        } catch {
            return []
        }
    }
    
    func getAllEntities() -> [EntityType] {
        return getAllEntitiesWith(predicate: nil, sortDescriptors: nil, fetchLimit: 0)
    }
    
    func createEntity() -> EntityType {
        let context = persistentContainer.viewContext
        return EntityType(context: context)
    }
    
}
