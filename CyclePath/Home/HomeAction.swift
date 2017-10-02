//
//  HomeAction.swift
//  CyclePath
//
//  Created by Guillaume Loulier on 26/09/2017.
//  Copyright © 2017 Guillaume Loulier. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreMotion
import CoreLocation

class HomeAction: UIViewController
{
    @IBOutlet weak var startBtn: CardButton!
    @IBOutlet weak var pauseBtn: CardButton!
    @IBOutlet weak var stopBtn: CardButton!
    
    
    @IBOutlet weak var dataCard: PathView!
    @IBOutlet weak var speedTxtLabel: UILabel!
    @IBOutlet weak var distanceTxtLabel: UILabel!
    @IBOutlet weak var timeTxtLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    private var timer: Timer?
    private var seconds = 0
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    let altimeterManager = CMAltimeter()
    private var altimeterTracking: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView.delegate = self as? MKMapViewDelegate
        locationManager.delegate = self
        mapView.showsUserLocation = true
        
        speedTxtLabel.text = ""
        distanceTxtLabel.text = ""
        timeTxtLabel.text = ""
        
        enableBasicLocationServices()
        
        HomeInteractor().checkAltimeterAvailability()
    }
    
    @IBAction func findUser(_ sender: Any)
    {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            HomeInteractor().centerMapOnUser(locationManager: locationManager, mapView: mapView, regionRadius: 1000)
        }
    }
    
    @IBAction func startTracking(_ sender: Any)
    {
        startBtn.isEnabled = false
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSeconds()
        }
        
        startLocationUpdates()
        
        HomeInteractor().startTrackingAltitude()
    }
    
    @IBAction func pauseTracking(_ sender: Any)
    {
        // TODO
    }
    
    @IBAction func stopTracking(_ sender: Any)
    {
        timer?.invalidate()
        HomeInteractor().stopUpdatingLocation(locationManager: locationManager)
        
        if Auth.auth().currentUser == nil {
            let alert = UIAlertController(
                title: "Are you logged in ?",
                message: "Do you want to save this path ?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: "Save", style: .default, handler: { (_) in
//                    self.performSegue(withIdentifier: "<#T##String#>", sender: <#T##Any?#>)
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            HomeManager().savePathsByUser(distance: self.distance.value, duration: Int16(self.seconds), locations: locationList, success: { (saved) in
                // TODO
                print("saved !")
            }, failure: { (failed) in
                // TODO
                print("Failed !")
            })
        }
        
        startBtn.isEnabled = true
    }
    
    func eachSeconds()
    {
        seconds += 1
        updateDisplay()
    }
    
    func updateDisplay()
    {
        let formattedDistance = HomeStruct.distance(distance)
        let formattedTime = HomeStruct.time(seconds)
        let formattedPace = HomeStruct.pace(distance: distance,
                                            seconds: seconds,
                                            outputUnit: UnitSpeed.minutesPerKilometer)
        
        distanceTxtLabel.text = formattedDistance
        timeTxtLabel.text = formattedTime
        speedTxtLabel.text = formattedPace
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
}

extension HomeAction: CLLocationManagerDelegate
{
    func enableBasicLocationServices() {
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            // Disable location features
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Enable location features
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        HomeInteractor().centerMapOnUser(locationManager: locationManager, mapView: mapView, regionRadius: 1000)
    }
}
