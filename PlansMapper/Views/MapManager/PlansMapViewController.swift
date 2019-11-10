//
//  PlansMapViewController.swift
//  PlansMapper
//
//  Created by falcon on 10/29/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import MapKit

class PlansMapViewController: UIViewController ,MKMapViewDelegate {
	
	@IBOutlet var mapView: MKMapView!
	let regionRadius: CLLocationDistance = 3000
	lazy var viewModel = PlansMapViewModel()
	lazy var nlpManager = NLP_Manager()
	var planVenues: [PlansMapModel] = []
	var planVenue: PlansMapModel?
	var currentUserLocation : CLLocation!
	var fakeLocation = CLLocation(latitude: -20.161971, longitude:  57.503238)
	var locationAllowed = false
	var searchTerms = [String]()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		
		searchTerms = nlpManager.generateMapSearchTerms(for: nlpManager.fullPlanText)
		checkLocationAuthorizationStatus()
		
		centerMapOnLocation(location: fakeLocation)  // use the current location var to get dynamic location
		
		mapView.register(ArtworkMarkerView.self,
						 forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
		
		
		searchPlaces(for: searchTerms)
	}
	
	func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
												  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
		mapView.setRegion(coordinateRegion, animated: true)
	}
	
	func searchPlaces(for itemNames: [String]) {
		for searchItem in itemNames {
			let searchRequest = MKLocalSearch.Request()
			searchRequest.naturalLanguageQuery = searchItem
			let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
			searchRequest.region = MKCoordinateRegion(center: currentUserLocation.coordinate, span: span)
			let search = MKLocalSearch(request: searchRequest)
			
			search.start(completionHandler: { (response, error) in
				if let resp = response {
					print("My Debug: Found: \(resp.mapItems.count) items on the map, for : \(searchItem)")
					for item in resp.mapItems {
						self.addPinToMapView(title: item.name, latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
						print("My Debug: Found item at: \(item.name!)")
					}
				}else{
					print("My Debug: Nothing found on the map for: \(searchItem)")
				}
			})
		}
		
	}
	
	
	func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
		if let title = title {
			let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
			let annotation = MKPointAnnotation()
			
			annotation.coordinate = location
			annotation.title = title
			
			mapView.addAnnotation(annotation)
		}
	}
	
	func checkLocationAuthorizationStatus() {
		let locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
			print("My Debug: current location found")
			currentUserLocation = locationManager.location
			mapView.showsUserLocation = true
			locationAllowed = true
		} else {
			print("My Debug: Using the fake locaton now...")
			currentUserLocation = fakeLocation
			locationManager.requestWhenInUseAuthorization()
		}
	}
	
	
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


extension PlansMapViewController : CLLocationManagerDelegate {



}
