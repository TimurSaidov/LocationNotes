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
    var folder: Folder?
    var inputFolder: Folder?
    var inputNoteFolder: Folder?
    var inputNoteLocation: LocationCoordinate?
    var isChangedImage: Bool = false
    var justCreatedNote: Bool?

    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var noteNameTextField: UITextField!
    @IBOutlet weak var noteDescriptionTextField: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var folderLabel: UILabel!
    @IBOutlet weak var nameFolderLabel: UILabel!
    
    @IBOutlet weak var folderImageView: UIImageView!
    @IBOutlet weak var locationImageView: UIImageView!
    
    @IBAction func umwindSegueFromSelectFolderTableViewController(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindSegue" {
            let svc = segue.source as! SelectFolderTableViewController
            folder = svc.folder
            
            if let note = note {
                note.folder = svc.note?.folder
            }
        }
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        saveButtonState()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        if let justCreatedNote = justCreatedNote {
            if !justCreatedNote {
                if let inputFolder = inputFolder {
                    note?.folder = inputFolder
                } else {
                    note?.folder = inputNoteFolder
                }
                note?.locationActual = inputNoteLocation
            } else {
                CoreDataManager.shared.managedObjectContext.delete(note!)
            }
            CoreDataManager.shared.saveContext()
        } else {
            note?.folder = inputNoteFolder
            note?.locationActual = inputNoteLocation
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let note = note {
            if note.name != noteNameTextField.text || note.textDescription != noteDescriptionTextField.text {
                note.dateUpdate = NSDate()
            }
            
            note.name = noteNameTextField.text
            note.textDescription = noteDescriptionTextField.text
            
            if isChangedImage {
                note.imageActual = noteImageView.image
            }
            
            CoreDataManager.shared.saveContext()
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        var activityItems: [Any] = []
        
        activityItems.append(note?.name ?? "")
        activityItems.append(note?.textDescription ?? "")
        if let image = note?.imageActual {
            activityItems.append(image)
        }
        
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        present(activityController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never

        locationImageView.layer.cornerRadius = 15
        locationImageView.clipsToBounds = true
        locationImageView.layer.borderWidth = 1
        locationImageView.layer.borderColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1) // UIColor.gray.cgColor
        
        inputFolder = folder // Пришедшая директория. nil, если заметка выбрана из Notes.
        inputNoteFolder = note?.folder // Директория пришедшей заметки.
        inputNoteLocation = note?.locationActual // Локация пришедшей заметки.
        
        if let inputNoteLocation = inputNoteLocation {
            print("Input Location - \(inputNoteLocation)")
        } else {
            print("Input Location - nil")
        }
        if let note = note {
            if let location = note.location {
                print(note.name!, location)
            } else {
                print(note.name! + ", nil")
            }
        }
    
        if note!.name != "" {
            navigationItem.title = note!.name
            noteNameTextField.text = note!.name
            noteDescriptionTextField.text = note!.textDescription
            noteImageView.image = note!.imageActual
        } else {
            navigationItem.title = "Note".localize() 
        }
        
        shareButtonState()
        saveButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let folder = folder {
            nameFolderLabel.text = folder.name
        } else if let folder = note?.folder {
            nameFolderLabel.text = folder.name
        } else {
            nameFolderLabel.text = "-"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return 175
        case (1, 0):
            return 175
        default:
            return 44
        }
    }

    let imagePicker: UIImagePickerController = UIImagePickerController()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            let alertController = UIAlertController(title: "Add photo using".localize(), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            let cameraAction = UIAlertAction(title: "Camera".localize(), style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
                self.imagePicker.sourceType = .camera
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            })
            let photoLibAction = UIAlertAction(title: "Library".localize(), style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            })
            let cancelAction = UIAlertAction(title: "Cancel".localize(), style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(cameraAction)
            alertController.addAction(photoLibAction)
            alertController.addAction(cancelAction)
            
            if self.noteImageView.image != nil {
                let deleteAction = UIAlertAction(title: "Delete".localize(), style: .destructive) { (action) in
                    self.noteImageView.image = nil
                }
                alertController.addAction(deleteAction)
            }
            
            self.present(alertController, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    func shareButtonState() {
        if !justCreatedNote! {
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectFolderSegue" {
            let dvc = segue.destination as! SelectFolderTableViewController
            dvc.note = note
            dvc.folder = folder
        }
        
        if segue.identifier == "MapSegue" {
            let dvc = segue.destination as! NoteMapViewController
            dvc.note = note
        }
    }
}

extension NoteTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        noteImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        isChangedImage = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
