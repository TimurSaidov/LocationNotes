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
        let newFolder = Folder(context: CoreDataManager.shared.managedObjectContext)
        
        newFolder.name = name
        newFolder.dateUpdate = NSDate()
        
        return newFolder
    }
    
    // Создание заметки непосредственно в выбранной папке. Не объект класса. То есть это метод готового экземпляра.
    func addNote() -> Note {
        let newNote = Note(context: CoreDataManager.shared.managedObjectContext)

        newNote.folder = self
        newNote.dateUpdate = NSDate()
        
        return newNote
    }
}
