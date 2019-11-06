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
	@IBOutlet var planDescTxtField: UITextView!
	
	//MARK: Properties
	let datePicker = UIDatePicker()
	lazy var dataManager = DataManager()
	lazy var notifManager = NotificationManager()
	lazy var alertManager = AlertsManager()
	var editMode = false
	var currentPlan : Plan?
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpUI()
	}
	
	override func willMove(toParent parent: UIViewController?) {
		//navigationItem.largeTitleDisplayMode = .always
		//navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	
	private func setUpUI(){
		self.title = "New Plan"
		//navigationController?.navigationBar.prefersLargeTitles = false
		txtFieldNewPlanTitle.delegate = self
		txtFldDeadline.delegate = self
		txtFieldNewPlanTitle.becomeFirstResponder()
		
		showDatePicker()

		
		if (editMode) {
			txtFieldNewPlanTitle.text = currentPlan?.title
		}
		
		let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBtnTapped))
		self.navigationItem.rightBarButtonItem  = saveBtn
	}
	
//	deinit {
//		NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification, object: nil)
//		NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
//		NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification, object: nil)
//	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		txtFieldNewPlanTitle.resignFirstResponder()
		txtFldDeadline.resignFirstResponder()
	}
	
	func configureKeyboard() {
		// Listen for keyboard notification
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
	}
	
	@objc func saveBtnTapped() {
		let calendar = Calendar.current
		let dateCreated = "Created: " + dataManager.getTimeNow()
		var due = "Due: "
		
		if let title = txtFieldNewPlanTitle.text, let deadline = txtFldDeadline.text, let desc = planDescTxtField.text {
			if (title != "" && deadline != "" && desc != "") {
				due += deadline
				
				if (editMode) {
					//dataManager.updateProject(title: currentProject!.name!, newTitle: title!)
					self.navigationController?.popViewController(animated: true)
				}else {
					let newPlan = Plan(dateCreated: dateCreated, title: title, desc: desc)
					do {
						try newPlan?.managedObjectContext?.save()
						print("Saved Plan: \(title) successfully")
					} catch { return }
				}
				
				// schedule the reminder
				notifManager.registerNotifCategories()
				let components = calendar.dateComponents([.second, .minute, .hour, .day, .month, .year], from:  getDateFromString(stringDate:deadline))
				notifManager.scheduceNotification(todoContent:title, year:components.year!, month:components.month!,day:components.day!,hour:components.hour!,minute:components.minute!,second:components.second!)
				
				self.navigationController?.popViewController(animated: true)

			}else {
				alertManager.showPlanSaveAlert(from: self)
			}
		}
	}
	
	
	//MARK: Dates and datepicker configurations
	
	func getDateFromString(stringDate:String) -> Date {
		
		let format = DateFormatter()
		format.dateFormat = "yyyy/MM/dd HH:mm:ss"
		//    let formattedDate = format.string(from: date)
		let realDate = format.date(from: stringDate)!
		return realDate
	}
	
	func showDatePicker(){
		
		let currentDate = Date()  //get the current date
		//Formate Date
		datePicker.datePickerMode = .dateAndTime
		datePicker.minimumDate = currentDate
		datePicker.date = currentDate
		
		//ToolBar
		let toolbar = UIToolbar();
		toolbar.sizeToFit()
		let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
		let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
		
		toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
		
		txtFldDeadline.inputAccessoryView = toolbar
		txtFldDeadline.inputView = datePicker
		
	}
	
	@objc func donedatePicker(){
		
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
		txtFldDeadline.text = formatter.string(from: datePicker.date)
		self.view.endEditing(true)
	}
	
	@objc func cancelDatePicker(){
		self.view.endEditing(true)
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

