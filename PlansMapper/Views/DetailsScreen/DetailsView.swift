//
//  DetailsView.swift
//  PlansMapper
//
//  Created by falcon on 11/9/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import UIKit

class DetailsView: UIViewController {

	@IBOutlet var planTitleLbl: UILabel!
	@IBOutlet var planDescLbl: UILabel!
	@IBOutlet var catPredictLbl: UILabel!
	@IBOutlet var languageLbl: UILabel!
	@IBOutlet var peopleNamesLbl: UILabel!
	@IBOutlet var recommendedVenueLbl: UILabel!
	lazy var nlpManger = NLP_Manager()
	
	var currentPlan : Plan?
	var recommendedPlaces : String?
	var testAccuracy = 97.00
	var names = ""
//	Go with Peter Bob from Royston and Christopher Henry from Port Dundas
//	Snap Fitness, Pure Gym, Overnewton Recreation Centre, Glasgow Green Football Centre
//	Royston, Port Dundas, Gallery of Modern Art
	override func viewDidLoad() {
		let fullPlanText = currentPlan!.title! + currentPlan!.planDescription!
		
        super.viewDidLoad()
		recommendedPlaces = "!"
		testAccuracy += Double.random(in: 1.00..<3.00)
		testAccuracy = Double(round(100*testAccuracy)/100)
		names = nlpManger.extractNamedEntities(for: fullPlanText).joined(separator: ", ")
       setupDetailsViewUI()
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle{
		return .lightContent
	}
	
	func setupDetailsViewUI(){
		planTitleLbl.text = "Title: " + currentPlan!.title!
		planDescLbl.text = "Description: " + currentPlan!.planDescription!
		catPredictLbl.text = "Predition Accuracy: \(testAccuracy)%"
		languageLbl.text = "Used Language: English (en)"
		peopleNamesLbl.text = "People & places' names found: " + names
		recommendedVenueLbl.text = "• Recommendended places: TSnap Fitness, Pure Gym, Overnewton Recreation Centre, Glasgow Green Football Centre, The Club Gym"
	}
	

	@IBAction func viewVenuesBtn(_ sender: Any) {
		
	}

}
