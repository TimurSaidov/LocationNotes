//
//  NoteMapViewController.swift
//  LocationNotes
//
//  Created by Timur Saidov on 12/11/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit
import MapKit

class NoteAnnotation: NSObject, MKAnnotation {
    var note: Note
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(note: Note) {
        self.note = note
        title = note.name
        if let folder = note.folder {
            subtitle = folder.name
        } else {
            subtitle = "-"
        }
        
        if note.locationActual != nil {
            coordinate = CLLocationCoordinate2D(latitude: note.locationActual!.lat, longitude: note.locationActual!.lon)
        } else {
            coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    }
}

class NoteMapViewController: UIViewController {
    
    var note: Note?

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        if note?.locationActual != nil {
            mapView.addAnnotation(NoteAnnotation(note: note!))
            mapView.centerCoordinate = CLLocationCoordinate2D(latitude: note!.locationActual!.lat, longitude: note!.locationActual!.lon)
        }
        
        let ltgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
        mapView.gestureRecognizers = [ltgr]
    }
    
    @objc func handleLongTap(recognizer: UIGestureRecognizer) {
        guard recognizer.state == .began else { return }
        
        let point = recognizer.location(in: mapView)
        let coordinates = mapView.convert(point, toCoordinateFrom: mapView)
        let newLocation = LocationCoordinate(lat: coordinates.latitude, lon: coordinates.longitude)
        note?.locationActual = newLocation
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(NoteAnnotation(note: note!))
    }
}

extension NoteMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.animatesDrop = true
        pin.isDraggable = true
        
        return pin
    }
    
    // Метод, вызывающийся при перетаскивании иголки на карте. Вызывается в течение всего перетаскивания, поэтому необходима проверка на окончание перетаскивания иглы.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            // Меняется локация заметки.
            let newLocation = LocationCoordinate(lat: (view.annotation?.coordinate.latitude)!, lon: (view.annotation?.coordinate.longitude)!)
            note?.locationActual = newLocation
        }
    }
}
