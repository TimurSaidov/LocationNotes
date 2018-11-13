//
//  MapViewController.swift
//  LocationNotes
//
//  Created by Timur Saidov on 12/11/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true // Текущая локация пользователя.
        
        let ltgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
        mapView.gestureRecognizers = [ltgr]
    }
    
    @objc func handleLongTap(recognizer: UIGestureRecognizer) {
        guard recognizer.state == .began else { return }
        
        let point = recognizer.location(in: mapView)
        let coordinates = mapView.convert(point, toCoordinateFrom: mapView)
        let newLocation = LocationCoordinate(lat: coordinates.latitude, lon: coordinates.longitude)
        
        let newNote = Note.newNote(name: "", inFolder: nil)
        newNote.locationActual = LocationCoordinate(lat: newLocation.lat, lon: newLocation.lon)

        addOrEditNoteFromMap(note: newNote, justCreatedNote: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        mapView.removeAnnotations(mapView.annotations)
        
        for note in notes {
            if note.locationActual != nil {
                mapView.addAnnotation(NoteAnnotation(note: note))
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print(Thread.current)
        
        if annotation is MKUserLocation {
            mapView.setCenter(annotation.coordinate, animated: true)
            return nil
        }
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.animatesDrop = true
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)

        return pin
    }
    
    // Метод для кнопки pin.rightCalloutAccessoryView, которая .detailDisclosure.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let selectedNote = (view.annotation as! NoteAnnotation).note
        
        addOrEditNoteFromMap(note: selectedNote, justCreatedNote: false)
    }
}

extension MapViewController {
    func addOrEditNoteFromMap(note: Note, justCreatedNote: Bool) {
        let noteController = storyboard?.instantiateViewController(withIdentifier: "noteSIB") as! NoteTableViewController
        noteController.note = note
        noteController.justCreatedNote = justCreatedNote
        
        navigationController?.pushViewController(noteController, animated: true)
    }
}
