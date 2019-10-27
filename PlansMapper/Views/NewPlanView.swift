//
//  NewPlanView.swift
//  PlansMapper
//
//  Created by falcon on 10/26/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import UIKit

class NewPlanView: UIViewController {
	
	//MARK: Outlets
	
	@IBOutlet var txtFieldNewPlanTitle: UITextField!
	@IBOutlet var txtFldDeadline: UITextField!
	
	//MARK: Properties
	
	lazy var dataManager = DataManager()
	//lazy var notifManager = NotificationManager()
	lazy var alertManager = AlertsManager()
	var editMode = false
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpUI()
	}
	
	
	private func setUpUI(){
		self.title = "New Plan"
		txtFieldNewPlanTitle.delegate = self
		txtFldDeadline.delegate = self
		//txtFieldNewPlanTitle.becomeFirstResponder()
		if (editMode) {
			//txtFieldNewPlanTitle.text = currentProject?.name
		}
		
		// Listen for keyboard notification
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
		
		let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBtnTapped))
		self.navigationItem.rightBarButtonItem  = saveBtn
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		txtFieldNewPlanTitle.resignFirstResponder()
		txtFldDeadline.resignFirstResponder()
	}
	
	
	@objc func saveBtnTapped() {
		let calendar = Calendar.current
		let dateCreated = "Created: " + dataManager.getTimeNow()
		var due = "Due: "
		
		if let title = txtFieldNewPlanTitle.text, let deadline = txtFldDeadline.text {
			if (title != "" && deadline != "") {
				due += deadline
				
				if (editMode) {
					//dataManager.updateProject(title: currentProject!.name!, newTitle: title!)
					self.navigationController?.popViewController(animated: true)
				}else {
					let newPlan = Plan(dateCreated: dateCreated, title: title)
					do {
						try newPlan?.managedObjectContext?.save()
						print("Saved Plan: \(title) successfully")
						self.navigationController?.popViewController(animated: true)
					} catch { return }
				}
			}else {
				alertManager.showPlanSaveAlert(from: self)
			}
		}
	}
	
}

//MARK: TextField delegate

extension NewPlanView: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	@objc func keyboardWillChange(notification:Notification) {
		guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
		if (notification.name == UIResponder.keyboardWillShowNotification ||
			notification.name == UIResponder.keyboardWillChangeFrameNotification) {
			view.frame.origin.y = -keyboardRect.height
		}else {
			view.frame.origin.y = 0
		}
		
	}
}

