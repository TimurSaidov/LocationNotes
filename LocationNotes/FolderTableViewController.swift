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

    override func viewDidLoad() {
        super.viewDidLoad()

        if let folder = folder {
            navigationItem.title = folder.name
        }
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

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
