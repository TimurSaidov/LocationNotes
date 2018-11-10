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
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        saveButtonState()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if note?.name != noteNameTextField.text || note?.textDescription != noteDescriptionTextField.text {
            note?.dateUpdate = NSDate()
        }
        
        note?.name = noteNameTextField.text
        note?.textDescription = noteDescriptionTextField.text
        
        CoreDataManager.shared.saveContext()
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noteNameTextField.text = note?.name
        noteDescriptionTextField.text = note?.textDescription
        
        saveButtonState()
    }
    
    func saveButtonState() {
        if noteNameTextField.text == "" {
            saveButton.isEnabled = false
        } else if noteNameTextField.text?.first == " " {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
}
