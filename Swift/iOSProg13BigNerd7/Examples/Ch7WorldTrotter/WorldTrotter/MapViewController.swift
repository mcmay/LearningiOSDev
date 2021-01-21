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
    var mapView: MKMapView!
    
    override func loadView() {
        // create a map view
        mapView = MKMapView()
        
        // Set it as *the* view of the this view controller
        view = mapView
        
        // let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let segmentedControl = UISegmentedControl(items: [standardString, hybridString, satelliteString])
        if #available(iOS 13.0, *) {
            segmentedControl.backgroundColor = UIColor.systemBackground
        } else {
            segmentedControl.backgroundColor = .orange
        }
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        let margins = view.layoutMarginsGuide
        segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func mapTypeChanged (_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex
        {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
}
