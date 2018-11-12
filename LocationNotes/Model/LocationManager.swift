//
//  LocationManager.swift
//  LocationNotes
//
//  Created by Timur Saidov on 12/11/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit
import CoreLocation

struct LocationCoordinate {
    var lat: Double
    var lon: Double
    
    static func create(location: CLLocation) -> LocationCoordinate {
        return LocationCoordinate(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    var manager = CLLocationManager()
    
    func requsetAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    var blockForSave: ((LocationCoordinate) -> Void)?
    
    func getCurrentCoordinate(block: ((LocationCoordinate) -> Void)?) {
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
//            let alertController = UIAlertController(title: "Allow this app to access your location", message: "You don't allow to access to your location. Please allow in the setting", preferredStyle: .alert)
//            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertController.addAction(ok)
//            present(alertController, animated: true, completion: nil)
//
//            print("Пользователь не дал доступ к локации!")
            return
        }
        
        blockForSave = block
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .other
        
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lc = LocationCoordinate.create(location: locations.last!)
        blockForSave?(lc)
        
        manager.stopUpdatingLocation()
    }
}
