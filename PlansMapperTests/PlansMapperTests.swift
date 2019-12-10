//
//  PlansMapperTests.swift
//  PlansMapperTests
//
//  Created by falcon on 12/7/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import XCTest
@testable import PlansMapper

class PlansMapperTests: XCTestCase {
	let testPlansList = [Plan]()
	var nlp_ManagerTester = NLP_Manager()
	
	
	var testPlanTitle = String ()
	var testPlanDesc = String ()
	var testPlanCat = String ()
	var testPlanDateCreated = String ()

	
    override func setUp() {
		testPlanTitle = "Test Plan Tile"
		testPlanDesc = "Test Plan Description"
		testPlanCat = "SHOPPING"
		testPlanDateCreated = "2019/12/08 16:26:14:575"
	}
	
	func testBuilProje(){
		
	}

	func testCreatePlan() {
		let newPlan = Plan(dateCreated: testPlanDateCreated, title: testPlanTitle, desc:testPlanDesc, cat: testPlanCat, completed: false)
		do {
			try newPlan?.managedObjectContext?.save()
			print("Saved new Plan successfully")
		} catch {
			print("Creating new plan failed")
		}
	}
	
	func testDeletePlan() {
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		let context = appDelegate.persistentContainer.viewContext
		let fetchRequest = getPlanFetchRequest()
		fetchRequest.predicate = NSPredicate(format: "title = %@", "\(testPlanTitle)")
		
		let test = try context.fetch(fetchRequest)
		guard let context = plan.managedObjectContext else { return }
		context.delete(plan)
		do {
			try context.save()
		} catch  {
			print("Unable to delete the test plan")
		}
	}
	
	func testLoadPlans() {
		
	}

	func testSearchPlans() {
		for item in 0...10 {
			print("item: \(item)")
		}
	}

	
	// Measuring performance of some functionalities.
    func testPerformanceExample() {
        self.measure {
            testLoadPlans()
        }
    }

}
