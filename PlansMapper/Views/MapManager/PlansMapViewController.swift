//
//  PlansMapViewController.swift
//  PlansMapper
//
//  Created by falcon on 10/29/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PlansMapViewController: UIViewController {

	@IBOutlet var mapView: MKMapView!
	let regionRadius: CLLocationDistance = 1000
	lazy var viewModel = PlansMapViewModel()
	var planVenues: [PlansMapModel] = []
	var planVenue: PlansMapModel?
	var currentUserLocation : CLLocation!
	var fakeLocation : CLLocation!
	var locationAllowed = false
	let locationManager = CLLocationManager()
	

    override func viewDidLoad() {
        super.viewDidLoad()
		mapView.delegate = self

		//fakeLocation = CLLocation(latitude:-20.275018, longitude: 57.578638)
		// set initial location as the current user location
		checkLocationAuthorizationStatus()
		
		centerMapOnLocation(location: currentUserLocation)
		
		mapView.register(ArtworkMarkerView.self,
						 forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
		
		//mapView.setRegion(planVenue.myRegion, animated: true)
		//loadInitialData()
		
		searchPlaces(for: "Shopping Mall")
    }
	
	func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
												  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
		mapView.setRegion(coordinateRegion, animated: true)
	}
	
	func searchPlaces(for item:String) {
		let searchRequest = MKLocalSearch.Request()
		searchRequest.naturalLanguageQuery = "Shopping Mall"
		
		let search = MKLocalSearch(request: searchRequest)
		
		search.start(completionHandler: { (response, error) in
			
			for item in response!.mapItems {
				let venue = PlansMapModel(locationName: item.name!, coordinate: CLLocationCoordinate2D(latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude))
				
				self.planVenues.append(venue)
				print("Found: \(venue.locationName), at lat: \(venue.coordinate.latitude), and at lon: \(venue.coordinate.longitude)")
				
			}
			
			self.mapView.addAnnotations(self.planVenues)

//			guard let response = response else {
//				print("Error: \(error?.localizedDescription ?? "Unknown error").")
//				return
//			}
			
			
			
		
	})
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
		planVenues.append(contentsOf: validWorks)
	}
	
	func checkLocationAuthorizationStatus() {
		if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
			currentUserLocation = locationManager.location
			mapView.showsUserLocation = true
			locationAllowed = true
		} else {
			locationManager.requestWhenInUseAuthorization()
		}
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
