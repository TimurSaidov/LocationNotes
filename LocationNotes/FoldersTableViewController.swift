//
//  FoldersTableViewController.swift
//  LocationNotes
//
//  Created by Timur Saidov on 06/11/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class FoldersTableViewController: UITableViewController {

    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        let alertConroller = UIAlertController(title: "Create new folder", message: "", preferredStyle: .alert)
        alertConroller.addTextField { (textField) in
            textField.placeholder = "Folder name"
        }
        
        let createAction = UIAlertAction(title: "Create", style: .default) { (action) in
            guard let folderName = alertConroller.textFields![0].text else { return }
            guard folderName != "" else { return }
            
            let _ = Folder.newFolder(name: folderName)
            
            CoreDataManager.shared.saveContext()
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertConroller.addAction(createAction)
        alertConroller.addAction(cancel)
        present(alertConroller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print(#function)
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(#function)
        
        return folders.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellFolder", for: indexPath) as! FoldersTableViewCell

        let folder = folders[indexPath.row]
        cell.folderNameLabel.text = folder.name
        cell.notesCountLabel.text = "\(folder.notesSorted.count) item(-s)"

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let folder = folders[indexPath.row]
            CoreDataManager.shared.managedObjectContext.delete(folder)
            CoreDataManager.shared.saveContext()
            
            tableView.deleteRows(at: [indexPath], with: .fade) // Вызов этого метода, вызывает еще и методы перезагрузки таблицы: numberOfSections(in:) и tableView(_:numberOfRowsInSection:), а поскольку folders - глобальная переменная, в которую данные загружаются из контекста, и которая вычисляется каждый раз, когда ее вызывают.
            
            print("Delete folder - \(#function)")
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FolderSegue", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FolderSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedFolder = folders[indexPath.row]
                let dvc = segue.destination as! FolderTableViewController
                dvc.folder = selectedFolder
            }
        }
    }
}
