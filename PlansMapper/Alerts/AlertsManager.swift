//
//  AlertsManager.swift
//  PlansMapper
//
//  Created by falcon on 10/27/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import UIKit

class AlertsManager {
	
	// show an alert on error while creating a plan
	func showPlanSaveAlert(from viewController: UIViewController) {
		
		let errorAlert = UIAlertController(title: "Error", message: "Make sure title, deadline and details are not empty", preferredStyle: .alert)
		let alertCancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		errorAlert.addAction(alertCancelAct)
		viewController.present(errorAlert, animated: true, completion: nil)
	}
	
	
	/// a general plansmapper UIAlert
	func showUIAlert(from viewController: UIViewController, title:String, saying message:String, okAction:String?, cancelAction:String?) {
		
		let myAlert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
		
		if okAction != nil {
			let alertOKAct = UIAlertAction(title: okAction, style: .default, handler: nil)
			myAlert.addAction(alertOKAct)
		}
		
		if cancelAction != nil {
			let alertCancelAct = UIAlertAction(title: cancelAction, style: .cancel, handler: nil)
			myAlert.addAction(alertCancelAct)
		}
		
		viewController.present(myAlert, animated: true, completion: nil)
	}
	// showing a simple toast
	func showToast(from viewController: UIViewController, message:String) {
		let alertDisapperTimeInSeconds = 1.0
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
		viewController.present(alert, animated: true)
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
			alert.dismiss(animated: true)
		}
	}
}
