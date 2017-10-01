//
//  HomeInteractor.swift
//  CyclePath
//
//  Created by Guillaume Loulier on 27/09/2017.
//  Copyright © 2017 Guillaume Loulier. All rights reserved.
//

import MapKit
import Foundation
import CoreMotion
import CoreLocation

class HomeInteractor
{
    private var timer: Timer?
    let locationManager = CLLocationManager()
    
    var altimeterTracking = false
    let altimeterManager = CMAltimeter()
    
    private var currentDistance: String = ""
    private var currentTime: String = ""
    private var currentPace: String = ""
    
    func setCurrentTimer(timer: Timer) {
        self.timer = timer
    }
    
    var getCurrentTimer: Timer {
        return self.timer!
    }
    
    var getCurrentDistance: String {
        return currentDistance
    }
    
    var getCurrentTime: String {
        return currentTime
    }
    
    var getCurrentPace: String {
        return currentPace
    }
}

extension HomeInteractor: HomeInteractorProtocol
{
    // Location
    
    func centerMapOnUser(locationManager: CLLocationManager, mapView: MKMapView, regionRadius: Double)
    {
        guard let coordinates = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinates, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func startTracking()
    {
        
    }
    
    func stopTimer()
    {
        timer?.invalidate()
    }
    
    func stopUpdatingLocation(locationManager: CLLocationManager)
    {
        locationManager.stopUpdatingLocation()
    }
    
    // Altimeter
    
    func checkAltimeterAvailability()
    {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeterTracking = true
        }
    }
    
    func startTrackingAltitude()
    {
        if altimeterTracking {
            altimeterManager.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { (data, errors) in
                if errors != nil {
                    print(errors?.localizedDescription as Any)
                }
                
                // TODO
            })
        }
    }
    
    func stopTrackingAltitude()
    {
        altimeterManager.stopRelativeAltitudeUpdates()
        
    }
    
    func saveAltitude()
    {
        
    }
}
