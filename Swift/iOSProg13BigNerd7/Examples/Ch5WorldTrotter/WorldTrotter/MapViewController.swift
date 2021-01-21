// 
//  Copyright © 2020 Big Nerd Ranch
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var mapView: MKMapView!
    
    override func loadView () {
        // Create a map view
        mapView = MKMapView()
        // Set it as *the* view of this view controller
        self.view = mapView
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.systemBackground
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(segmentedControl)
        /*let topConstraint = segmentedControl.topAnchor.constraint(equalTo: self.view.topAnchor)
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)*/
        segmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        let margins = self.view.layoutMarginsGuide
        segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        let label = UILabel()
        label.text = "Points of interest"
        label.backgroundColor = UIColor.systemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        label.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8.0).isActive = true
        label.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor).isActive = true
        
        let aSwitch = UISwitch()
        aSwitch.translatesAutoresizingMaskIntoConstraints = false
        aSwitch.addTarget(self, action: #selector(pointOfInterestChanged(_ :)), for: .valueChanged)
        self.view.addSubview(aSwitch)
        aSwitch.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8.0).isActive = true
        aSwitch.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8.0).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("MapViewController loaded its view.")
    }

    @objc func mapTypeChanged (_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
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
    @objc func pointOfInterestChanged (_ aSwitch: UISwitch) {
        if aSwitch.isOn {
            mapView.pointOfInterestFilter = .includingAll
        } else {
            mapView.pointOfInterestFilter = .excludingAll
        }
    }
}
