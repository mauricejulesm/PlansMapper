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

	override func viewDidLoad() {
        super.viewDidLoad()

       setupDetailsViewUI()
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle{
		return .lightContent
	}
	
	func setupDetailsViewUI(){
		planTitleLbl.text = "Title: \(currentPlan?.title)"
		planDescLbl.text = currentPlan?.planDescription
		catPredictLbl.text = "80%"
		languageLbl.text = currentPlan?.title
		peopleNamesLbl.text = currentPlan?.title
		recommendedVenueLbl.text = currentPlan?.title
	}
	

	@IBAction func viewVenuesBtn(_ sender: Any) {
		
	}

}
