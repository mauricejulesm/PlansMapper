//
//  DataManager.swift
//  PlansMapper
//
//  Created by falcon on 10/23/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//
import UIKit
import CoreData

class DataManager  {
	
	func updatePlanStatus(title:String) {
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		let context = appDelegate.persistentContainer.viewContext
		let fetchRequest = getPlanFetchRequest()
		fetchRequest.predicate = NSPredicate(format: "title = %@", "\(title)")
		do{
			let test = try context.fetch(fetchRequest)
			let planToUpdate = test[0]
			planToUpdate.completed ? planToUpdate.setValue(false, forKey: "completed") : planToUpdate.setValue(true, forKey: "completed")
			try context.save()
		}catch{
			print(error)
		}
		print("Object: \(title) updated")
	}
	
	
	
	func editPlan(title:String, newPlanTitle:String, newDesc: String) {
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		
		let context = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = getPlanFetchRequest()
		// fetchRequest.predicate = NSPredicate(format: "title = %@ AND dateCreated = %@", title, date)           // for more precision
		fetchRequest.predicate = NSPredicate(format: "title = %@", "\(title)")
		do{
			let test = try context.fetch(fetchRequest)
			let planToUpdate = test[0]
			planToUpdate.setValue(newPlanTitle, forKey: "title")
			planToUpdate.setValue(newDesc, forKey: "planDescription")
			try context.save()
		}catch{
			print(error)
		}
		
		print("Task: \(title) updated to: \(newPlanTitle)")
	}
	
	
	// get the fetchRequest
	func getPlanFetchRequest() -> NSFetchRequest<Plan> {
		let fetchRequest : NSFetchRequest<Plan> = Plan.fetchRequest()
		return fetchRequest
	}
	

	// getting the file path of the sqlite file
	func applicationDocumentsDirectory() {
		if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
			print(url.absoluteString)
		}
	}
	
	func getTimeNow() -> String {
		let date = Date()
		let format = DateFormatter()
		format.dateFormat = "yyyy/MM/dd HH:mm:ss:SSS"
		
		let formattedDate = format.string(from: date)
		//let realDate = format.date(from: formattedDate)!
		
		return formattedDate
	}
	
	

}
