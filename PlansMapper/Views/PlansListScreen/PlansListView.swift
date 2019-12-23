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
	@IBOutlet var plansSearchBar: UISearchBar!
	
	var searchMode = false
	
	// categorised
	var sportsCat = [Plan]()
	var foodCat = [Plan]()
	var shoppingCat = [Plan]()
	var otherCat = [Plan]()
	var completedCat = [Plan]()
	lazy var alertManager = AlertsManager()

	let tableSections = ["SHOPPING","SPORTS", "FOOD", "OTHER", "COMPLETED"]
	var currentPlansInSections = [Int: [Plan]]()
	var cachedPlansData = [Int: [Plan]]()

	
	// MARK: - Class properties
	var plansList = [Plan]()
	lazy var dataManager = DataManager()
	var fullPlanText = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		plansTableView.delegate = self
		plansTableView.dataSource = self
		plansTableView.register(UINib(nibName: "PlanCell", bundle: nil), forCellReuseIdentifier: "PlanCell")
		locationManager.requestWhenInUseAuthorization()
		UNUserNotificationCenter.current().delegate = self
		plansSearchBar.delegate = self
		navigationItem.hidesSearchBarWhenScrolling = true
	}
	
	override func viewWillAppear(_ animated: Bool) {
		assignCategories()
		self.plansTableView.reloadData()
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle{
		return .lightContent
	}
	
	/// a private functions to assing plans categories
	func fetchPlansFromDB() {
		plansList = []
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
			else { return }
		let context = appDelegate.persistentContainer.viewContext
		let fetchRequest = dataManager.getPlanFetchRequest()
		let sortDesc = NSSortDescriptor(key: "dateCreated", ascending: false)
		fetchRequest.sortDescriptors = [sortDesc]
		do {
			plansList = try context.fetch(fetchRequest)
		} catch  { print("Unable to fetch plans") }
	}
	
	/// a private functions to assing plans categories
	private func assignCategories() {
		fetchPlansFromDB()
		
		sportsCat = []; foodCat = []; shoppingCat = []; otherCat = []; completedCat = []
		
		print(plansList.count)
		if plansList.count > 1 {
			for plan in plansList {
				let planCat = plan.value(forKey: "category") as! String
				let completed = plan.value(forKey: "completed") as! Bool
				if (!completed){
					switch planCat.lowercased() {
					case "sports":
						sportsCat.append(plan)
					case "food":
						foodCat.append(plan)
					case "shopping":
						shoppingCat.append(plan)
					default:
						otherCat.append(plan)
					}
				}else{
					completedCat.append(plan)
				}
			}
		}
		currentPlansInSections = [0:shoppingCat, 1:sportsCat, 2:foodCat, 3:otherCat,4:completedCat]
		cachedPlansData = currentPlansInSections
	}
	
	/// logout action
	@IBAction func logoutBtnTapped(_ sender: Any) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "LoginView") as! LoginView
		self.dismiss(animated: true, completion: nil)
		navigationController?.present(vc, animated: true)
	}
}

// MARK: - TableView datasource methods

extension PlansListView : UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return tableSections.count
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView()
		let headerLbl = UILabel()
		headerLbl.frame = CGRect(x: 60, y: 8, width: 250, height: 30)
		headerLbl.text = tableSections[section]
		headerLbl.textAlignment = .center
		headerLbl.layer.cornerRadius = 5
		headerLbl.backgroundColor = .orange
		headerLbl.textColor = .white
		headerView.addSubview(headerLbl)
		return headerView
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 33
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return currentPlansInSections[section]!.count
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = plansTableView.dequeueReusableCell(withIdentifier:"PlanCell", for: indexPath) as! PlanCell
		let plan = currentPlansInSections[indexPath.section]![indexPath.row]
		cell.isAccessibilityElement = false
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
		let goToMap = goPlanAction(at: indexPath)
		let swipeAction = UISwipeActionsConfiguration(actions: [goToMap])
		swipeAction.isAccessibilityElement = true
		swipeAction.accessibilityValue = "Go To Map"
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
			vc.currentPlan = self.currentPlansInSections[indexPath.section]![indexPath.row]
			vc.editMode = true
			self.navigationController?.pushViewController(vc, animated: true)
			completion(true)
		}
		action.image = UIImage(named: "edit_icon")
		return action
	}
	
	func goPlanAction(at indexPath: IndexPath) -> UIContextualAction {
		let title = currentPlansInSections[indexPath.section]![indexPath.row].title!
		let desc = currentPlansInSections[indexPath.section]![indexPath.row].planDescription!
		fullPlanText = title + " " + desc
		let action = UIContextualAction(style: .normal, title: "Go") { (action, view, completion ) in
			let mpView = self.storyboard?.instantiateViewController(withIdentifier: "PlansMapViewController") as! PlansMapViewController
			mpView.fullPlanText = self.fullPlanText
			self.navigationController?.pushViewController(mpView, animated: true)
			completion(true)
		}
		action.image = UIImage(named: "done_icon")
		action.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
		
		return action
	}
	
	func deletePlan(at indexPath: IndexPath) -> UIContextualAction{
		let plan = currentPlansInSections[indexPath.section]![indexPath.row]
		let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
			guard let context = plan.managedObjectContext else { return }
			context.delete(plan)
			do {
				try context.save()
				self.currentPlansInSections[indexPath.section]!.remove(at: indexPath.row)
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
		assignCategories()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
			self.plansTableView.reloadData()
		}
		print("The switch is \(sender.isOn ? "ON" : "OFF")")
	}
	
}

// MARK: - Tableview delegate methods

extension PlansListView : UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let detailsView = (storyboard?.instantiateViewController(withIdentifier: "DetailsView")) as! DetailsView
		detailsView.currentPlan = self.currentPlansInSections[indexPath.section]![indexPath.row]
		self.navigationController?.pushViewController(detailsView, animated: true)
		
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
		var filteredPlans = [Int: [Plan]]()
		if searchText != "" {
			filteredPlans = currentPlansInSections.mapValues { $0.filter {($0.title?.lowercased()
				.contains(searchText.lowercased()))! } }
			currentPlansInSections = filteredPlans
		}else{
			currentPlansInSections = cachedPlansData
		}
		searchMode = true
		self.plansTableView.reloadData()
	}
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}

extension UINavigationController {
	open override var preferredStatusBarStyle: UIStatusBarStyle {
		return topViewController?.preferredStatusBarStyle ?? .default
	}
}
