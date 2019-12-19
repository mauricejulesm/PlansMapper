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
	var plansTestList = [Plan]()
	
	var newPlan = Plan()
	
    override func setUp() {
		testPlanTitle = "Test Plan Tile"
		testPlanDesc = "Test Plan Description"
		testPlanCat = "SHOPPING"
		testPlanDateCreated = "2019/12/08 16:26:14:575"
		
		newPlan = Plan(dateCreated: testPlanDateCreated, title: testPlanTitle, desc:testPlanDesc, cat: testPlanCat, completed: false)!

	}
	

	func testCreatePlan() {
		let newPlan = Plan(dateCreated: testPlanDateCreated, title: testPlanTitle, desc:testPlanDesc, cat: testPlanCat, completed: false)
		do {
			try newPlan?.managedObjectContext?.save()
		} catch {
			print("Creating new plan failed")
		}
	}

	func testDeletePlan() {
			guard let context = newPlan.managedObjectContext else { return }
			context.delete(newPlan)
			do {
				try context.save()
			} catch  {
				print("Unable to delete the plan ")
			}
	}

	func testEditPlan() {
		let newPlan = Plan(dateCreated: testPlanDateCreated, title: testPlanTitle, desc:testPlanDesc, cat: testPlanCat, completed: false)
		do {
			try newPlan?.managedObjectContext?.save()
		} catch {
			print("Creating new plan failed")
		}
	}


	func testFetchPlans() {
		let newPlan = Plan(dateCreated: testPlanDateCreated, title: testPlanTitle, desc:testPlanDesc, cat: testPlanCat, completed: false)
		do {
			try newPlan?.managedObjectContext?.save()
		} catch {
			print("Creating new plan failed")
		}
		
		let newPlan2 = Plan(dateCreated: testPlanDateCreated, title: testPlanTitle, desc:testPlanDesc, cat: testPlanCat, completed: false)
		do {
			try newPlan2?.managedObjectContext?.save()
		} catch {
			print("Creating new plan failed")
		}
		
		let newPlan3 = Plan(dateCreated: testPlanDateCreated, title: testPlanTitle, desc:testPlanDesc, cat: testPlanCat, completed: false)
		do {
			try newPlan3?.managedObjectContext?.save()
		} catch {
			print("Creating new plan failed")
		}
	}

	// Measuring performance of some functionalities.
//    func testPerformanceExample() {
//        self.measure {
//            //PlansListView.fetchPlansFromDB()
//        }
    }


