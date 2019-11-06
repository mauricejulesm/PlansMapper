//
//  Plan+CoreDataProperties.swift
//  PlansMapper
//
//  Created by falcon on 10/26/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//
//

import Foundation
import CoreData


extension Plan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plan> {
        return NSFetchRequest<Plan>(entityName: "Plan")
    }

    @NSManaged public var dateCreated: String?
	@NSManaged public var title: String?
	@NSManaged public var planDescription: String?

}
