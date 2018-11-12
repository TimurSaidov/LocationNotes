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
    var imageActual: UIImage? {
        get {
            if let image = self.image {
                if let imageBig = image.imageBig {
                    return UIImage(data: imageBig as Data)
                }
            }
            return nil
        }
        set(newValue) {
            if newValue == nil {
                if let image = self.image {
                    CoreDataManager.shared.managedObjectContext.delete(image)
                }
                self.imageSmall = nil
            } else {
                if self.image == nil {
                    self.image = ImageNote(context: CoreDataManager.shared.managedObjectContext)
                }
                
                self.image?.imageBig = newValue?.jpegData(compressionQuality: 1) as NSData?
                self.imageSmall = newValue?.jpegData(compressionQuality: 0.1) as NSData?
            }
            dateUpdate = NSDate()
        }
    }
    
    var locationActual: LocationCoordinate? {
        get {
            if self.location == nil { // self.location - св-во экземпляра Note.
                return nil
            }
            return LocationCoordinate(lat: self.location!.latitude, lon: self.location!.longitude)
        }
        set(newValue) {
            if newValue == nil && self.location != nil {
                // Удаление локации.
                CoreDataManager.shared.managedObjectContext.delete(self.location!)
            }
            if newValue != nil && self.location != nil {
                // Обновление локации.
                self.location?.latitude = newValue!.lat
                self.location?.longitude = newValue!.lon
            }
            if newValue != nil && self.location == nil {
                // Создание локации.
                let newLocation = Location(context: CoreDataManager.shared.managedObjectContext)
                newLocation.latitude = newValue!.lat
                newLocation.longitude = newValue!.lon
                self.location = newLocation
            }
        }
    }
    
    func addCurrentLocation() {
        LocationManager.shared.getCurrentCoordinate { (location) in
            self.locationActual = location
            print("Получена новая локация: \(location)")
        }
    }
    
    class func newNote(name: String, inFolder: Folder?) -> Note {
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
