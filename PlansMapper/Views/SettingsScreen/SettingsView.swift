//
//  SettingsView.swift
//  PlansMapper
//
//  Created by Maurice on 10/22/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import UIKit
import MapKit

enum MapType {
	case hybrid, satellite, standard
}

class SettingsView: UIViewController {
	@IBOutlet var mapTypeSegments: UISegmentedControl!
	@IBOutlet var settingDetailsScrollView: UIScrollView!
	
	var mapTypeChosen : MapType?

	override func viewDidLoad() {
        super.viewDidLoad()
		
		settingDetailsScrollView.alpha = 0.0
		
    }

	@IBAction func viewHelpPageBtn(_ sender: Any) {
	}
	
	@IBAction func viewAppVersionBtn(_ sender: Any) {
	}
	
	@IBAction func mapTypeSegmentPressed(_ sender: Any) {
		
		if mapTypeSegments.selectedSegmentIndex == 0 {
			UserDefaults.standard.set(0, forKey: "plansMapType")
		}
		else if mapTypeSegments.selectedSegmentIndex == 1 {
			UserDefaults.standard.set(1, forKey: "plansMapType")
		} else if mapTypeSegments.selectedSegmentIndex == 2{
			UserDefaults.standard.set(2, forKey: "plansMapType")
		}
	}
}

