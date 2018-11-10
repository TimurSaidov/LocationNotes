//
//  Note+CoreDataClass.swift
//  LocationNotes
//
//  Created by Timur Saidov on 06/11/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit


public class Note: NSManagedObject {
    class func newNote(name: String, inFolder: Folder?) -> Note { // Создание заметки в Notes Tab Bar'а.
        let newNote = Note(context: CoreDataManager.shared.managedObjectContext)
        
        newNote.name = name
        newNote.dateUpdate = NSDate()
        
        if let inFolder = inFolder {
            newNote.folder = inFolder
        }
        
        return newNote
    }
    
    func addImage(image: UIImage) {
        let imageNote = ImageNote(context: CoreDataManager.shared.managedObjectContext)
        
        imageNote.imageBig = image.jpegData(compressionQuality: 1) as NSData?
        
        self.image = imageNote
    }
    
    func addLocation(latitude: Double, longitude: Double) {
        let locationNode = Location(context: CoreDataManager.shared.managedObjectContext)
        
        locationNode.latitude = latitude
        locationNode.longitude = longitude
        
        self.location = locationNode
    }
}
