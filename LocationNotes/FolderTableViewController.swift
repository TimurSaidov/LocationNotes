//
//  FolderTableViewController.swift
//  LocationNotes
//
//  Created by Timur Saidov on 10/11/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class FolderTableViewController: UITableViewController {
    
    var folder: Folder?
    var notesActual: [Note] { // Поскольку класс принадлежит двум контроллерам на view, то есть переменная, отвечающая за массив заметок: либо это заметки из конкретной директории, либо это все заметки (из глобальной переменной в CoreDataManager.swift).
        if let folder = folder {
            return folder.notesSorted
        }
        return notes
    }
    var selectedNote: Note?
    
    @IBAction func pushAddAction(_ sender: UIBarButtonItem) {
        selectedNote = nil // Обнуляется, поскольку по возвращении с NoteTableViewController'а selectedNote остается тем же, каким был до перехода на NoteTableViewController. 
        performSegue(withIdentifier: "NoteSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let folder = folder {
            navigationItem.title = folder.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("FolderTableViewController - \(#function)")
        if let name = selectedNote?.name {
            print("SelectedNote - " + name)
        }
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notesActual.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellNote", for: indexPath)

        let note = notesActual[indexPath.row]
        cell.textLabel?.text = note.name
        cell.detailTextLabel?.text = FormatterDate.df.string(from: note.dateUpdate! as Date)
        
        if let imageSmall = note.imageSmall {
            cell.imageView?.image = UIImage(data: imageSmall as Data)
        } else {
            cell.imageView?.image = nil
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let note = notesActual[indexPath.row]
            CoreDataManager.shared.managedObjectContext.delete(note)
            CoreDataManager.shared.saveContext()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notesActual[indexPath.row]
        selectedNote = note
        performSegue(withIdentifier: "NoteSegue", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NoteSegue" {
            let dvc = segue.destination as! UINavigationController
            let noteTableVC = dvc.viewControllers.first! as! NoteTableViewController
            noteTableVC.note = selectedNote
            noteTableVC.folder = folder
        }
    }
}
