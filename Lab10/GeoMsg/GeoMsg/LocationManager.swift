//
//  LocationManager.swift
//  GeoMsg
//
//  Created by Beni Kis on 12/11/2023.
//

import Foundation
import CoreLocation

protocol LocationObserver : AnyObject {
    func updateLocation(_ location: CLLocation)
}

class LocationManager : NSObject {
    var locationObserver : LocationObserver?
    var lastLocation: CLLocation?
    
    private var timeoutTimer: Timer?
    private var locationManager: CLLocationManager!
    
    func startLocationManager() {
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        timeoutTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(LocationManager.stopLocationManager), userInfo: nil, repeats: false)
        
        locationManager.startUpdatingLocation()
    }
    
    @objc func stopLocationManager() {
        if let timer = timeoutTimer {
            timer.invalidate()
        }
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        
        if -newLocation.timestamp.timeIntervalSinceNow > 5.0 {
            return
        }
        
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        if lastLocation == nil || lastLocation!.horizontalAccuracy > newLocation.horizontalAccuracy {
            
            lastLocation = newLocation
            locationObserver?.updateLocation(newLocation)
            
            if newLocation.horizontalAccuracy <= manager.desiredAccuracy {
                stopLocationManager()
            }
        }
    }
}
