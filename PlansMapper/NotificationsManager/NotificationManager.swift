//
//  NotificationManager.swift
//  PlansMapper
//
//  Created by falcon on 10/27/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//


import UIKit
import UserNotifications

class NotificationManager: NSObject {
	
	// register notification categories
	func registerNotifCategories() {
		let center = UNUserNotificationCenter.current()
		//center.delegate = self
		
		let show = UNNotificationAction(identifier: "show", title: "View your plan", options: .foreground)
		let remindMe = UNNotificationAction(identifier: "dismiss", title: "Dismiss", options: .foreground)
		let category = UNNotificationCategory(identifier: "planReminderCatgr", actions: [show, remindMe], intentIdentifiers: [])
		
		center.setNotificationCategories([category])
	}
	
	
	// schedule the notification
	func scheduceNotification(planContent:String, year:Int,month:Int,day:Int,hour:Int,minute:Int,second:Int) {
		
		let notifCenter = UNUserNotificationCenter.current()
		
		let content = UNMutableNotificationContent()
		content.title = "Your plan reminder"
		//content.subtitle = "This is your reminder subtitle"
		content.body = "\(planContent)"
		content.categoryIdentifier = "planReminderCatgr"
		content.badge = 1
		content.userInfo = ["customData": "fizzbuzz"]
		content.sound = UNNotificationSound.default
		
		//var dateNow = getDateObject(stringDate: "2019-09-24 10:15:19")
		var dateComponents = DateComponents()
		dateComponents.year = year
		dateComponents.month = month
		dateComponents.day = day
		dateComponents.hour = hour
		dateComponents.minute = minute
		dateComponents.second = second
		
	let trigger = UNCalendarNotificationTrigger( dateMatching: dateComponents,
		repeats: true )
	let notifRequest = UNNotificationRequest( identifier: "PlansMapper.Notification",
		content: content, trigger: trigger )
	notifCenter.add(notifRequest)
	print("Notification scheduled! with id \(notifRequest.identifier)")
	}
	
	func removePlanNotification(){
		UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["PlansMapper.Notification"])
		print("Notification was removed")
	}
	
}
