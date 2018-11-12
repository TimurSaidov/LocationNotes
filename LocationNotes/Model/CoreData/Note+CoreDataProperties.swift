//
//  Note+CoreDataProperties.swift
//  LocationNotes
//
//  Created by Timur Saidov on 06/11/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var dateUpdate: NSDate?
    @NSManaged public var imageSmall: NSData?
    @NSManaged public var textDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var folder: Folder?
    @NSManaged public var location: Location?
    @NSManaged public var image: ImageNote?

}
