//
//  User+CoreDataClass.swift
//  PlansMapper
//
//  Created by falcon on 10/26/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//
//

import UIKit
import CoreData

@objc(User)
public class User: NSManagedObject {

	var plans: [Plan]? {
		return self.rawPlans?.array as? [Plan]
	}
	
	convenience init?(username:String, password: String){
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		
		guard let context = appDelegate?.persistentContainer.viewContext else {
			return nil
		}
		self.init(entity: User.entity(), insertInto: context)
		self.username = username
		self.password = password
	}
}
