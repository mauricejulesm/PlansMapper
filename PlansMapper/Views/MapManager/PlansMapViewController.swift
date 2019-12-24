//
//  PlansMapViewController.swift
//  PlansMapper
//
//  Created by falcon on 10/29/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import MapKit



class PlansMapViewController: UIViewController {
	
	@IBOutlet var mapView: MKMapView!
	let regionRadius: CLLocationDistance = 3000
	lazy var viewModel = PlansMapViewModel()
	lazy var nlpManager = NLP_Manager()
	var currentUserLocation : CLLocation!
	var testLocation = CLLocation(latitude: 55.866828, longitude:  -4.250016)
	var locationAllowed = false
	var searchTerms = [String]()
	var fullPlanText : String!
	var settingsView = SettingsView()
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		searchTerms = nlpManager.generateMapSearchTerms(for: fullPlanText)
		checkLocationAuthorizationStatus()
		centerMapOnLocation(on: testLocation)  // use the current location var to get dynamic location
		mapView.register(ArtworkMarkerView.self,
						 forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
		searchPlaces(for: searchTerms)
		
		switch UserDefaults.standard.integer(forKey: "plansMapType") {
		case 2:
			mapView.mapType = .hybrid
		case 1:
			mapView.mapType = .satellite
		default:
			mapView.mapType = .standard
		}
		
		//print("This segment is selected: \()")
	}
	
	func centerMapOnLocation(on userLocation: CLLocation) {
		let coordinateRegion = MKCoordinateRegion(center: userLocation.coordinate,
												  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
		mapView.setRegion(coordinateRegion, animated: true)
		
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle{
		return .lightContent
	}
	
	func addPinToMapView(title: String?, subtitle: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
		if let title = title, let subtitle = subtitle {
			let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
			let planMapAnnotation = PlansMapModel(title: title, locationName: subtitle, coordinate: location)
			mapView.addAnnotation(planMapAnnotation)
		}
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
				 calloutAccessoryControlTapped control: UIControl) {
		let location = view.annotation as! PlansMapModel
		let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
		location.mapItem().openInMaps(launchOptions: launchOptions)
	}
	
	// searching places on the map using map search terms from NLP_Manager class
	private func searchPlaces(for mapSearchTerms: [String]) {
		for item in mapSearchTerms {
			let searchRequest = MKLocalSearch.Request()
			searchRequest.naturalLanguageQuery = item
			let regionSpan = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
			searchRequest.region = MKCoordinateRegion(center: currentUserLocation.coordinate, span: regionSpan)
			let search = MKLocalSearch(request: searchRequest)
			
			// start searching
			search.start(completionHandler: { (response, error) in
				if let resp = response {
					print("Debug: Found: \(resp.mapItems.count) items on the map, for : \(item)")
					for item in resp.mapItems {
						self.addPinToMapView(title: item.placemark.name, subtitle: item.placemark.country, latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
						print("App Debug: Found item at: \(item.name!)")
					}
				}else{ print("Debug: Nothing found on the map for: \(item)") }
			})}
	}
}


extension PlansMapViewController : MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard let annotation = annotation as? PlansMapModel else { return nil }
		let identifier = "marker";
		var view: MKMarkerAnnotationView
		if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
			as? MKMarkerAnnotationView {
			dequeuedView.annotation = annotation
			view = dequeuedView
		} else {
			view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			view.canShowCallout = true;
			view.calloutOffset = CGPoint(x: -5, y: 5)
			view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) }
		return view
	}
}


extension PlansMapViewController : CLLocationManagerDelegate {
	// requesting the location access from the user
	private func checkLocationAuthorizationStatus() {
		let locationManager = CLLocationManager()
		locationManager.delegate = self; locationManager.desiredAccuracy = kCLLocationAccuracyBest
		if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
			print("Debug: current location found")
			currentUserLocation = testLocation
			mapView.showsUserLocation = true; locationAllowed = true
		} else {
			currentUserLocation = testLocation
			locationManager.requestWhenInUseAuthorization()
		}}
	
}
