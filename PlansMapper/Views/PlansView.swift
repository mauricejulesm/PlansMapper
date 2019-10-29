//
//  PlansView.swift
//  PlansMapper
//
//  Created by falcon on 10/23/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import UIKit

enum PlansTableState {
    case hasData
    case hasNoData
}

class PlansView: UIViewController {
    
    

	// MARK: - Class outlets
	@IBOutlet weak var plansTableView: UITableView!

	// MARK: - Class properties
	var plansList = [Plan]()
	lazy var dataManager = DataManager()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		plansTableView.register(UINib(nibName: "PlanCell", bundle: nil), forCellReuseIdentifier: "PlanCell")
    }
	
	override func viewWillAppear(_ animated: Bool) {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
			else { return }
		let context = appDelegate.persistentContainer.viewContext
		let fetchRequest = dataManager.getPlanFetchRequest()
		let sortDesc = NSSortDescriptor(key: "dateCreated", ascending: false)
		fetchRequest.sortDescriptors = [sortDesc]
		do {
			plansList = try context.fetch(fetchRequest)
			self.plansTableView.reloadData()
		} catch  {
			print("Unable to fetch plans")
		}
	}
    
    fileprivate func setTableState (_ state : PlansTableState){
        switch state {
        case .hasData:
            self.plansTableView.alpha = 1.0
        case .hasNoData:
            self.plansTableView.alpha = 0.0
        }
    }
    
}


// MARK: - TableView datasource methods

extension PlansView : UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return plansList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = plansTableView.dequeueReusableCell(withIdentifier:"PlanCell", for: indexPath) as! PlanCell
		cell.planTitleLbl?.text = plansList[indexPath.row].title
		cell.planDescLbl?.text = plansList[indexPath.row].dateCreated
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			deletePlan(at: indexPath)
		}
	}
}


// MARK: - Tableview delegate methods

extension PlansView : UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		plansTableView.deselectRow(at: indexPath, animated: false)
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
	}
}

// MARK: - private functionlities
private extension PlansView {

	func deletePlan(at indexPath: IndexPath) {
		let plan = plansList[indexPath.row]
		guard let context = plan.managedObjectContext else { return }
		context.delete(plan)
		do {
			try context.save()
			plansList.remove(at: indexPath.row)
			self.plansTableView.deleteRows(at: [indexPath], with: .automatic)
		} catch  {
			print("Unable to delete the category")
			//self.plansTableView.reloadRows(at: [indexPath], with: .automatic)
		}
		
	}
	
//	@IBAction func addPlanBtnTapped(_ sender: Any) {
//		let newPlanView = storyboard?.instantiateViewController(withIdentifier: "NewPlanView") as! NewPlanView
//		show(newPlanView, sender: self)
//		//present(newPlanView, animated: true, completion: nil)
//
//	}
}
