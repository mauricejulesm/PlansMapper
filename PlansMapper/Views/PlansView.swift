//
//  PlansView.swift
//  PlansMapper
//
//  Created by falcon on 10/23/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import UIKit

class PlansView: UIViewController {

	// MARK: - Class properties
	@IBOutlet weak var plansTableView: UITableView!

	var plansList = ["Plan1", "Plan 2", "Plan 3", "Plan 2", "Plan 3", "Plan 2", "Plan 3", "Plan 2", "Plan 3", "Plan 2", "Plan 3"]
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		plansTableView.register(UINib(nibName: "PlanCell", bundle: nil), forCellReuseIdentifier: "PlanCell")
    }
}


// MARK: - UITableViewController delegate methods

extension PlansView : UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return plansList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = plansTableView.dequeueReusableCell(withIdentifier:"PlanCell", for: indexPath) as! PlanCell
		cell.planTitleLbl?.text = plansList[indexPath.row]
		cell.planDescLbl?.text = "Plan details ..."

		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			plansList.remove(at: indexPath.row)
			plansTableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		plansTableView.deselectRow(at: indexPath, animated: false)
	}

	
}
// MARK: - private functionlities
private extension PlansView {
	
	@IBAction func userDidTapLogout(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func addPlanBtnTapped(_ sender: Any) {
		let newPlanView = storyboard?.instantiateViewController(withIdentifier: "NewPlanView") as! NewPlanView
		show(newPlanView, sender: self)
		//present(newPlanView, animated: true, completion: nil)
		
	}
}
