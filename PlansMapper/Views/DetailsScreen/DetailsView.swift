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
	@IBOutlet var placeNamesLbl: UILabel!
	@IBOutlet var peopleNamesLbl: UILabel!
	@IBOutlet var recommendedVenueLbl: UILabel!
	
	var currentPlan : Plan?
	var recommendedPlaces : String?
	

	override func viewDidLoad() {
        super.viewDidLoad()
		recommendedPlaces = "No place found!"
       setupDetailsViewUI()
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle{
		return .lightContent
	}
	
	func setupDetailsViewUI(){
		planTitleLbl.text = "Title: " + currentPlan!.title!
		planDescLbl.text = "Description: " + currentPlan!.planDescription!
		catPredictLbl.text = "Predition %: " + "80% Accuracy"
		languageLbl.text = "Used Language: English" + currentPlan!.title!
		peopleNamesLbl.text = "People's names found: James, Vicent" + currentPlan!.title!
		placeNamesLbl.text = "Places names found: Super U, Grand Bay" + currentPlan!.title!
		recommendedVenueLbl.text = "Recommendended places: " + recommendedPlaces!
	}
	

	@IBAction func viewVenuesBtn(_ sender: Any) {
		
	}

}
