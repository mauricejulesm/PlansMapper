//
//  PlansView.swift
//  PlansMapper
//
//  Created by falcon on 10/23/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

enum PlansTableState {
    case hasData
    case hasNoData
}

class PlansListView: UIViewController, UNUserNotificationCenterDelegate {
	let locationManager = CLLocationManager()
	
	// MARK: - Class outlets
	@IBOutlet weak var plansTableView: UITableView!
	@IBOutlet var blankTableImg: UIImageView!
	
	// MARK: - plans arrays
	var planItems  = [Plan]()
	var completedPlans = [Plan]()
	var incompletePlans = [Plan]()
	var currentPlans = [Plan]()
	var unSortedPlans = [Plan]()
	var subTasks = [Plan]()
	
	// MARK: - Class properties
	var plansList = [Plan]()
	lazy var dataManager = DataManager()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		plansTableView.delegate = self
		plansTableView.dataSource = self
		plansTableView.register(UINib(nibName: "PlanCell", bundle: nil), forCellReuseIdentifier: "PlanCell")
		locationManager.requestWhenInUseAuthorization()
		UNUserNotificationCenter.current().delegate = self
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
	
	func assignPlans() {
		completedPlans = []
		incompletePlans = []
		
		for plan in planItems {
			if (plan.value(forKey: "completed") as! Bool == true){
				completedPlans.append(plan)
			}else{
				incompletePlans.append(plan)
			}
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

extension PlansListView : UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return plansList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = plansTableView.dequeueReusableCell(withIdentifier:"PlanCell", for: indexPath) as! PlanCell
		let plan = plansList[indexPath.row]
		cell.planTitleLbl?.text = plan.title
		cell.planDescLbl?.text = plan.planDescription
		cell.dateCreatedLbl?.text = plan.dateCreated
		
		let isComplete = plan.value(forKey: "completed") as? Bool

		let switchView = cell.doneSwitch!
		isComplete ?? false ? switchView.setOn(true, animated: true) : switchView.setOn(false, animated: true)
		switchView.tag = indexPath.row
		switchView.accessibilityLabel = plan.value(forKey: "title") as? String
		switchView.addTarget(self, action: #selector(self.onPlanStatusChanged(_:)), for: .valueChanged)
		//cell.accessoryView = switchView

		
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			_ = deletePlan(at: indexPath)
		}
	}
	
	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let done = completePlanAction(at: indexPath)
		return UISwipeActionsConfiguration(actions: [done])
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let edit = editPlanAction(at: indexPath)
		let delete = deletePlan(at: indexPath)
		
		return UISwipeActionsConfiguration(actions: [edit, delete])
	}
	
	
	func editPlanAction(at indexPath: IndexPath) -> UIContextualAction {
		let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion ) in
			print("Edit tapped")
			completion(true)
		}
		action.image = UIImage(named: "edit_icon")
		//action.backgroundColor = .gray
		return action
	}
	
	func completePlanAction(at indexPath: IndexPath) -> UIContextualAction {
		let action = UIContextualAction(style: .destructive, title: "Done") { (action, view, completion ) in
			print("done tapped")
			
			completion(true)
		}
		action.image = UIImage(named: "done_icon")
		action.backgroundColor = .green
		return action
	}
	
	func deletePlan(at indexPath: IndexPath) -> UIContextualAction{
		let plan = plansList[indexPath.row]
		let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
			guard let context = plan.managedObjectContext else { return }
			context.delete(plan)
			do {
				try context.save()
				self.plansList.remove(at: indexPath.row)
				self.plansTableView.deleteRows(at: [indexPath], with: .automatic)
			} catch  {
				print("Unable to delete the category")
			}
			completion(true)
		}
		action.image = UIImage(named: "trash_icon")
		return action
	}
	
	@objc func onPlanStatusChanged(_ sender : UISwitch!){
		let currentPlanTitle = sender.accessibilityLabel

		self.dataManager.updatePlanStatus(title:currentPlanTitle!)
		
		//self.currentPlans.remove(at: sender.tag)
		//self.assignPlans()
		
		//self.plansTableView.reloadData()
		print("The switch is \(sender.isOn ? "ON" : "OFF")")
	}
	
}


// MARK: - Tableview delegate methods

extension PlansListView : UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		plansTableView.deselectRow(at: indexPath, animated: false)
		
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
	}
}

// MARK: - private functionlities
private extension PlansListView {

	
}
