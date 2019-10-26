//
//  User+CoreDataProperties.swift
//  PlansMapper
//
//  Created by falcon on 10/26/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var password: String?
    @NSManaged public var username: String?
    @NSManaged public var rawPlans: NSOrderedSet?

}

// MARK: Generated accessors for rawPlans
extension User {

    @objc(addRawPlansObject:)
    @NSManaged public func addToRawPlans(_ value: Plan)

    @objc(removeRawPlansObject:)
    @NSManaged public func removeFromRawPlans(_ value: Plan)

    @objc(addRawPlans:)
    @NSManaged public func addToRawPlans(_ values: NSSet)

    @objc(removeRawPlans:)
    @NSManaged public func removeFromRawPlans(_ values: NSSet)

}
