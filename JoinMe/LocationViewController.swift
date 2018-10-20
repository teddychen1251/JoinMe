//
//  LocationViewController.swift
//  JoinMe
//
//  Created by Tim Tan on 10/20/18.
//  Copyright © 2018 Teddy Chen. All rights reserved.
//

import UIKit

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    var location: CLLocation?
    let manager = CLLocationManager()
    
    var mapView: GMSMapView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        GMSServices.provideAPIKey("AIzaSyBi3kdvjC4VJ1gMejnNwEomde5YOHBPM1A")
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.distanceFilter = 20
        manager.startUpdatingLocation()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        
        let currentLocation:CLLocationCoordinate2D = manager.location!.coordinate
        
        let camera = GMSCameraPosition.camera(withLatitude: (currentLocation.latitude), longitude: (currentLocation.longitude), zoom: 15)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        let marker = GMSMarker(position: currentLocation)
        marker.title = "Me"
        marker.map = mapView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

