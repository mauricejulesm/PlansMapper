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
		
		let errorAlert = UIAlertController(title: "Error", message: "Make sure title and deadline are not empty", preferredStyle: .alert)
		let alertCancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		errorAlert.addAction(alertCancelAct)
		viewController.present(errorAlert, animated: true, completion: nil)
	}
	
	// showing a simple toast
	func showToast(from viewController: UIViewController, message:String) {
		let alertDisapperTimeInSeconds = 2.0
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
		viewController.present(alert, animated: true)
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
			alert.dismiss(animated: true)
		}
	}
}
