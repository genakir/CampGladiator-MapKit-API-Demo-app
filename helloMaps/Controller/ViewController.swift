//
//  ViewController.swift
//  helloMaps
//
//  Created by Gennadii Kiryushatov on 10/28/20.
//  Copyright © 2020 Gennadii Kiryushatov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private let locationManager = CLLocationManager() // to get a real location
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        
        fetchDataCodable { (locationsData) in
            for index in 0..<locationsData.data.count {
                let sampleAnnotation = Annotations(title: locationsData.data[index].placeName, coordinate: CLLocationCoordinate2D(latitude: Double(locationsData.data[index].placeLatitude) ?? 30.4071008, longitude: Double(locationsData.data[index].placeLongitude) ?? -97.7167636))
                self.mapView.addAnnotation(sampleAnnotation)
            }
        }
        
        self.mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // request for permissions
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // accuracy
        locationManager.distanceFilter = kCLDistanceFilterNone // how much device should be moved to get a change in location
        locationManager.startUpdatingLocation() // update location on View load
        self.mapView.showsUserLocation = true
        
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        switchBetweenLocations()
        self.mapView.showsUserLocation = false
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBetweenLocations()
        self.mapView.showsUserLocation = false
        searchTextField.endEditing(true)
        return true
    }
    
    func switchBetweenLocations() {
        switch searchTextField.text {
        case "Dallas":
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 32.7767, longitude: -96.7970), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            mapView.setRegion(region, animated: true)
        case "Orlando":
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 28.5383, longitude: -81.3792), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            mapView.setRegion(region, animated: true)
        case "Nashville":
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.1627, longitude: -86.7816), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            mapView.setRegion(region, animated: true)
        case "Atlanta":
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33.7490, longitude: -84.3880), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            mapView.setRegion(region, animated: true)
        default:
            // Austin
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.2672, longitude: -97.7431), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            mapView.setRegion(region, animated: true)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type a city name, please"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.text = ""
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
    }
    
    func fetchDataCodable(completionHandler: @escaping (LocationsData) -> Void) {
        // Hit the API endpoint
        let urlString = "https://stagingapi.campgladiator.com/api/v2/places/searchbydistance?lat=30.406991&lon=-97.720310&radius=25"
        let url = URL(string: urlString)
        guard url != nil else {
            return
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            // Check for errors
            if error == nil && data != nil {
                // Parse JSON
                let decoder = JSONDecoder()
                
                do  {
                    let locationsData = try decoder.decode(LocationsData.self, from: data!)
                    completionHandler(locationsData)
                }
                catch {
                    print("Error in JSON parsing")
                }
                
            }
        }
        // Make the API Call
        dataTask.resume()
    }
    
}

