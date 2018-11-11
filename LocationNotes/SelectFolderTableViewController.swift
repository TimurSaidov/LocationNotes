//
//  SelectFolderTableViewController.swift
//  LocationNotes
//
//  Created by Timur Saidov on 11/11/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class SelectFolderTableViewController: UITableViewController {

    var note: Note?
    var folder: Folder?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return folders.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectFolderCell", for: indexPath)

        if indexPath.row == 0 {
            cell.textLabel?.text = "-"
            
            if folder != nil {
                cell.accessoryType = .none
            } else {
                if let note = note {
                    if note.folder != nil {
                        cell.accessoryType = .none
                    } else {
                        cell.accessoryType = .checkmark
                    }
                } else {
                    cell.accessoryType = .checkmark
                }
            }
        } else {
            let folderInCell = folders[indexPath.row - 1]
            cell.textLabel?.text = folderInCell.name
            
            if let folder = folder {
                if folderInCell == folder {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            } else {
                if let note = note {
                    if folderInCell == note.folder {
                        cell.accessoryType = .checkmark
                    } else {
                        cell.accessoryType = .none
                    }
                } else {
                    cell.accessoryType = .none
                }
            }
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            if folder != nil {
                folder = nil
                
                if let note = note {
                    note.folder = nil
                }
            } else {
                if let note = note {
                    note.folder = nil
                }
            }
        
            tableView.reloadSections([0], with: UITableView.RowAnimation.fade)
        } else {
            let folderInCell = folders[indexPath.row - 1]
            folder = folderInCell
            
            if let note = note {
                note.folder = folderInCell
            }
            
            tableView.reloadSections([0], with: UITableView.RowAnimation.fade)
        }
    }
}
