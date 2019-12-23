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
	lazy var alertManager = AlertsManager()
	
	var mapTypeChosen : MapType?

	override func viewDidLoad() {
        super.viewDidLoad()
		
		
    }

	@IBAction func viewHelpPageBtn(_ sender: Any) {
		alertManager.showUIAlert(from: self, title: "••• HELP PAGE •••", saying:
"""

• ABOUT PLANSMAPPER

PLANSMAPPER is mobile apps which uses Natural Language Processing and Apple Maps to create a smart activity planning mobile application.

• HOW TO USE THE APP
			
When you open the app for the first time, you will be greeted by a welcome screen / login screen.
put your login credentials correctly.
After login, you will be taken to a fresh screen where you can add you plans, edit, delete and interact with them.

*TO VIEW THE MAP: To view the map, swipe right on the plan you want to see
*TO VIEW DETAILS: To view the plan's details, tap on the plan's a new screen will be open containing more details about the app.

			
• OUR MISSION

Its goal is to make the experience of people who uses productivity and navigation apps better by developing an app called PlansMapper. This app uses Natural Language Processing (NLP) to process user’s plans then intelligently arrange them into categories and find their venues on the map. To achieve this aim, mobile application development processes were used to analyze, design, and implement an iOS mobile app. The app was built using the Swift programming language in XCode IDE. The app was also tested in both simulated and physical environments.


•Developer: Jules Maurice Mulisa
""", okAction: "OK", cancelAction: nil)
	}
	
	@IBAction func viewAppVersionBtn(_ sender: Any) {
		alertManager.showUIAlert(from: self, title: "Version Details", saying: "App Version: V2.1.2", okAction: "OK", cancelAction: nil)
	}
	
	@IBAction func mapTypeSegmentPressed(_ sender: Any) {
		
		if mapTypeSegments.selectedSegmentIndex == 0 {
			UserDefaults.standard.set(0, forKey: "plansMapType")
			alertManager.showToast(from: self, message: "Map style changed to Standard")
		}
		else if mapTypeSegments.selectedSegmentIndex == 1 {
			UserDefaults.standard.set(1, forKey: "plansMapType")
			alertManager.showToast(from: self, message: "Map style changed to Satellite")
		} else if mapTypeSegments.selectedSegmentIndex == 2{
			UserDefaults.standard.set(2, forKey: "plansMapType")
			alertManager.showToast(from: self, message: "Map style changed to Hybrid")
		}
	}
}

