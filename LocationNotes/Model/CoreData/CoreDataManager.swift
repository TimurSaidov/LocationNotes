//
//  CoreDataManager.swift
//  LocationNotes
//
//  Created by Timur Saidov on 06/11/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit
import CoreData

var folders: [Folder] {
    let request = NSFetchRequest<Folder>(entityName: "Folder")
    
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true) // Сортировщик, сортирующий директории по name.
    request.sortDescriptors = [sortDescriptor]
    
    do {
        let array = try CoreDataManager.shared.managedObjectContext.fetch(request) // (_ request: NSFetchRequest<T>) throws -> [T], где request: NSFetchRequest<Folder>, array: [Folder].
        
        print("Folders count!")
        
        return array
    } catch {
        print(error.localizedDescription)
    }
    
    return []
}

var notes: [Note] {
    let request = NSFetchRequest<Note>(entityName: "Note")
    
    let sortDescriptor = NSSortDescriptor(key: "dateUpdate", ascending: false)
    request.sortDescriptors = [sortDescriptor]
    
    do {
        let array = try CoreDataManager.shared.managedObjectContext.fetch(request)
        
        return array
    } catch {
        print(error.localizedDescription)
    }
    
    return []
}

class CoreDataManager: NSObject {
    
    static let shared = CoreDataManager()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "LocationNotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

class FormatterDate {
    static let df: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        return dateFormatter
    }()
}