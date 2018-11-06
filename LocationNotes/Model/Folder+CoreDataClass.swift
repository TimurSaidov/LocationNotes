//
//  Folder+CoreDataClass.swift
//  LocationNotes
//
//  Created by Timur Saidov on 06/11/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//
//

import Foundation
import CoreData


public class Folder: NSManagedObject {
    class func newFolder(name: String) -> Folder {
        let folder = Folder(context: CoreDataManager.shared.managedObjectContext)
        
        folder.name = name
        folder.dateUpdate = NSDate()
        
        return folder
    }
}
