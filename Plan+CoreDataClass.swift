//
//  Plan+CoreDataClass.swift
//  PlansMapper
//
//  Created by falcon on 10/26/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Plan)
public class Plan: NSManagedObject {	
	
	convenience init?(dateCreated:String, title: String, desc: String, cat:String, completed:Bool){
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		
		guard let context = appDelegate?.persistentContainer.viewContext else {
			return nil
		}
		self.init(entity: Plan.entity(), insertInto: context)
		self.dateCreated = dateCreated
		self.title = title
		self.planDescription = desc
		self.category = cat
		self.completed = completed
	}
}
