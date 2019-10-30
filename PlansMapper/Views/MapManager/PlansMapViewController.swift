//
//  PlansMapViewController.swift
//  PlansMapper
//
//  Created by falcon on 10/29/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import UIKit
import MapKit

class PlansMapViewController: UIViewController {

	@IBOutlet var mapView: MKMapView!
	let regionRadius: CLLocationDistance = 1000
	lazy var viewModel = PlansMapViewModel()
	var artworks: [PlansMapModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
		mapView.delegate = self

		// set initial location in Honolulu
		let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
		centerMapOnLocation(location: initialLocation)
		
		// show artwork on map
//		let artwork = PlansMapModel(title: "Maurice Jr. The Falcon",
//							  locationName: "Falcon Land",
//							  discipline: "Spirit",
//							  coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
//		mapView.addAnnotation(artwork)

		loadInitialData()
		mapView.addAnnotations(artworks)

    }
	
	func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
												  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
		mapView.setRegion(coordinateRegion, animated: true)
	}
	
	func loadInitialData() {
		guard let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json") else { return }
		let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
		
		guard
			let data = optionalData,
			let json = try? JSONSerialization.jsonObject(with: data),
			let dictionary = json as? [String: Any],
			let works = dictionary["data"] as? [[Any]] else { return }
		let validWorks = works.compactMap { PlansMapModel(json: $0) }
		artworks.append(contentsOf: validWorks)
	}
}


extension PlansMapViewController : MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard let annotation = annotation as? PlansMapModel else { return nil }
		let identifier = "marker"
		var view: MKMarkerAnnotationView
		if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
			as? MKMarkerAnnotationView {
			dequeuedView.annotation = annotation
			view = dequeuedView
		} else {
			view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			view.canShowCallout = true
			view.calloutOffset = CGPoint(x: -5, y: 5)
			view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
		}
		return view
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
				 calloutAccessoryControlTapped control: UIControl) {
		let location = view.annotation as! PlansMapModel
		let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
		location.mapItem().openInMaps(launchOptions: launchOptions)
	}
	

}
