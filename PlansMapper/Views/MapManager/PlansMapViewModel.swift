//
//  PlansMapViewModel.swift
//  PlansMapper
//
//  Created by falcon on 10/30/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import MapKit
import Contacts


class PlansMapViewModel: NSObject {
	
	var mapModel: PlansMapModel?

	// Annotation right callout accessory opens this mapItem in Maps app
	func mapIvtem() -> MKMapItem {
		let addressDict = [CNPostalAddressStreetKey: mapModel!.subtitle!]
		let placemark = MKPlacemark(coordinate: mapModel!.coordinate, addressDictionary: addressDict)
		let mapItem = MKMapItem(placemark: placemark)
		mapItem.name = mapModel!.title
		return mapItem
	}
}
