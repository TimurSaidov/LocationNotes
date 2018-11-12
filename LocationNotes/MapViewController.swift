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
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.animatesDrop = true
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)

        return pin
    }
    
    // Метод для кнопки pin.rightCalloutAccessoryView, которая .detailDisclosure.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let selectedNote = (view.annotation as! NoteAnnotation).note
        let noteController = storyboard?.instantiateViewController(withIdentifier: "noteSIB") as! NoteTableViewController
        noteController.note = selectedNote
        
        navigationController?.pushViewController(noteController, animated: true)
    }
}
