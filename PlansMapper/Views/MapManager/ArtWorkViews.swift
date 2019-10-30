//
//  ArtWorkViews.swift
//  PlansMapper
//
//  Created by falcon on 10/30/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import MapKit

class ArtworkMarkerView: MKMarkerAnnotationView {
	override var annotation: MKAnnotation? {
		willSet {
			// 1
			guard let artwork = newValue as? PlansMapModel else { return }
			canShowCallout = true
			calloutOffset = CGPoint(x: -5, y: 5)
			rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
			// 2
			markerTintColor = artwork.markerTintColor
			glyphText = String(artwork.discipline.first!)
		}
	}
}
