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
	@IBOutlet weak var segmentController: UISegmentedControl!
	@IBOutlet var plansSearchBar: UISearchBar!
	
	// MARK: - plans arrays
	var planItems  = [Plan]()
	var completedPlans = [Plan]()
	var incompletePlans = [Plan]()
	var currentPlans = [Plan]()
	var unSortedPlans = [Plan]()
	var subTasks = [Plan]()
	var searchMode = false
	
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
		
		plansSearchBar.delegate = self
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
		assignPlans()
		if (segmentController.selectedSegmentIndex == 0){ currentPlans = incompletePlans }
		self.plansTableView.reloadData()
	}
	
	func assignPlans() {
		completedPlans = []
		incompletePlans = []
		
		for plan in plansList {
			if (plan.value(forKey: "completed") as! Bool == true){
				completedPlans.append(plan)
			}else{
				incompletePlans.append(plan)
			}
		}
	}
	
	// MARK: - Segments and status changing
	@IBAction func switchSegments(_ sender: UISegmentedControl){
		if sender.selectedSegmentIndex == 0  {
			currentPlans = incompletePlans
		}else{
			currentPlans = completedPlans
		}
		self.plansTableView.reloadData()
	}
}


// MARK: - TableView datasource methods

extension PlansListView : UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return currentPlans.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = plansTableView.dequeueReusableCell(withIdentifier:"PlanCell", for: indexPath) as! PlanCell
		let plan = currentPlans[indexPath.row]
		cell.planTitleLbl?.text = plan.title
		cell.planDescLbl?.text = plan.planDescription
		cell.dateCreatedLbl?.text = plan.dateCreated
		
		let isComplete = plan.value(forKey: "completed") as? Bool

		let switchView = cell.doneSwitch!
		isComplete ?? false ? switchView.setOn(true, animated: true) : switchView.setOn(false, animated: true)
		switchView.tag = indexPath.row
		switchView.accessibilityLabel = plan.value(forKey: "title") as? String
		switchView.addTarget(self, action: #selector(self.onPlanStatusChanged(_:)), for: .valueChanged)
		return cell
	}
	
	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let done = completePlanAction(at: indexPath)
		let swipeAction = UISwipeActionsConfiguration(actions: [done])
		swipeAction.performsFirstActionWithFullSwipe = false
		return swipeAction
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let edit = editPlanAction(at: indexPath)
		let delete = deletePlan(at: indexPath)
		let swipeActions = UISwipeActionsConfiguration(actions: [edit, delete])
		swipeActions.performsFirstActionWithFullSwipe = false
		return swipeActions
	}
	
	
	func editPlanAction(at indexPath: IndexPath) -> UIContextualAction {
		let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion ) in
			print("Edit tapped")
			let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewPlanView") as! NewPlanView
			vc.currentPlan = self.currentPlans[indexPath.row]
			vc.editMode = true
			self.navigationController?.pushViewController(vc, animated: true)
			completion(true)
		}
		action.image = UIImage(named: "edit_icon")
		return action
	}
	
	func completePlanAction(at indexPath: IndexPath) -> UIContextualAction {
		let action = UIContextualAction(style: .normal, title: "Done") { (action, view, completion ) in
			print("done tapped")
			
			completion(true)
		}
		action.image = UIImage(named: "done_icon")
		action.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
		return action
	}
	
	func deletePlan(at indexPath: IndexPath) -> UIContextualAction{
		let plan = currentPlans[indexPath.row]
		let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
			guard let context = plan.managedObjectContext else { return }
			context.delete(plan)
			
			if (self.segmentController.selectedSegmentIndex == 0){
				self.incompletePlans.remove(at: indexPath.row)
			}else{
				self.completedPlans.remove(at: indexPath.row)
			}
			
			do {
				try context.save()
				self.currentPlans.remove(at: indexPath.row)
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
		self.currentPlans.remove(at: sender.tag)
		self.assignPlans()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
			self.plansTableView.reloadData()
		}
		print("The switch is \(sender.isOn ? "ON" : "OFF")")
	}
	
}

// MARK: - Tableview delegate methods

extension PlansListView : UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		plansTableView.deselectRow(at: indexPath, animated: false)
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		if !searchMode {
			let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 70, 0)
			cell.layer.transform = rotationTransform
			cell.alpha = 0
			
			UIView.animate(withDuration: 0.75) {
				cell.layer.transform = CATransform3DIdentity
				cell.alpha = 1.0
			}
		}
	}
}


// MARK: - Searchbar and Searching

extension PlansListView : UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		var filteredArray = [Plan]()
		
		if searchText != "" {
			filteredArray = currentPlans.filter() { ($0.title?.lowercased()
				.contains(searchText.lowercased()))!}
			currentPlans = filteredArray
		}else{
			currentPlans = segmentController.selectedSegmentIndex == 0 ? incompletePlans : completedPlans
		}
		searchMode = true
		self.plansTableView.reloadData()
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}
// MARK: - private functionlities
private extension PlansListView {

	
}
