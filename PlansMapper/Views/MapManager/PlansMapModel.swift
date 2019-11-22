//
//  PlnsMapModel.swift
//  PlansMapper
//
//  Created by falcon on 10/29/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import MapKit
import Contacts

class PlansMapModel: NSObject, MKAnnotation {
	
	let locationName: String
	let coordinate: CLLocationCoordinate2D
	
	init(locationName: String, coordinate: CLLocationCoordinate2D) {
		self.locationName = locationName
		self.coordinate = coordinate
		
		super.init()
	}
	
	var subtitle: String? {
		return locationName
	}
	
	
	init?(json: [Any]) {
		// 1
		self.locationName = json[12] as! String
		// 2
		if let latitude = Double(json[18] as! String),
			let longitude = Double(json[19] as! String) {
			self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		} else {
			self.coordinate = CLLocationCoordinate2D()
		}
	}
	
	// markerTintColor for disciplines: Sculpture, Plaque, Mural, Monument, other
//	var markerTintColor: UIColor  {
//		switch discipline {
//		case "Monument":
//			return .red
//		case "Mural":
//			return .cyan
//		case "Plaque":
//			return .blue
//		case "Sculpture":
//			return .purple
//		default:
//			return .green
//		}
//	}
	
	
	// Annotation right callout accessory opens this mapItem in Maps app
	func mapItem() -> MKMapItem {
		let addressDict = [CNPostalAddressStreetKey: subtitle!]
		let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
		let mapItem = MKMapItem(placemark: placemark)
//		mapItem.name = title
		return mapItem
	}
	
	var myRegion : MKCoordinateRegion {
		let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
		return MKCoordinateRegion(center: coordinate, span: span)
	}
	
}
