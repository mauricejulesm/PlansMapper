//
//  MapView.swift
//  PlansMapper
//
//  Created by falcon on 10/29/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIViewController {

	@IBOutlet var mapView: MKMapView!
	let regionRadius: CLLocationDistance = 1000

	
    override func viewDidLoad() {
        super.viewDidLoad()

		// set initial location in Honolulu
		let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
		centerMapOnLocation(location: initialLocation)
		
		// show artwork on map
		let artwork = MapViewModel(title: "Maurice Jr. The Falcon",
							  locationName: "Falcon Land",
							  discipline: "Spirit",
							  coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
		mapView.addAnnotation(artwork)

    }
	
	func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
												  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
		mapView.setRegion(coordinateRegion, animated: true)
	}

    

	

}
