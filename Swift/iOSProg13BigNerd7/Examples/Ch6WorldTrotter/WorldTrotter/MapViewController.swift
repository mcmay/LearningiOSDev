//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Chao Mei on 7/12/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    let cllm = CLLocationManager()
    
    override func viewDidLoad() {
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.cllm.requestWhenInUseAuthorization()
    }
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        mapView.region = MKCoordinateRegion(center: cllm.location?.coordinate ?? CLLocationCoordinate2D(latitude: -37.81693328271199, longitude: 145.123528203653481), latitudinalMeters: 100.0, longitudinalMeters: 100.0)
        //mapView.setRegion(region, animated: true) Desn't work. Don't know why.
    }
}
