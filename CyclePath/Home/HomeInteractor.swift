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
    private var altimeterData: [Double] = []
    
    private var currentDistance: String = ""
    private var currentTime: String = ""
    private var currentPace: String = ""
    
    // Altimeter
    
    var getAltimeterData: [Double] {
        return altimeterData
    }
    
    // Timer
    
    func setCurrentTimer(timer: Timer) {
        self.timer = timer
    }
    
    var getCurrentTimer: Timer {
        return self.timer!
    }
    
    // Location
    
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
                
                self.altimeterData.append((data?.relativeAltitude.doubleValue)!)
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
    
    func transformLocations(locations: [CLLocation], data: @escaping (_ : [LocationStruct.persist]) -> ())
    {
        var locationArray = [LocationStruct.persist]()
        
        for location in locations {
            let locationStruct = LocationStruct.persist(timestamp: location.timestamp, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            locationArray.append(locationStruct)
        }
        
        data(locationArray)
    }
}
