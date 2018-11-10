//
//  NoteTableViewController.swift
//  LocationNotes
//
//  Created by Timur Saidov on 10/11/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class NoteTableViewController: UITableViewController {
    
    var note: Note?

    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var noteNameTextField: UITextField!
    @IBOutlet weak var noteDescriptionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noteNameTextField.text = note?.name
        noteDescriptionTextField.text = note?.textDescription
    }
}
