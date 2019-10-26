//
//  AppDelegate.swift
//  PlansMapper
//
//  Created by Maurice on 10/22/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "PlansMapper")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
	
	// MARK: - Nofitications registering
	func registerLocal() {
		let notifCenter = UNUserNotificationCenter.current()
		
		notifCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
			if granted {
				print("The app was allowed to send notifications")
			} else {
				print("The app was denied to send notifications")
			}
		}
	}

}

