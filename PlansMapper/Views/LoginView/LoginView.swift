//
//  LoginView.swift
//  PlansMapper
//
//  Created by falcon on 12/23/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import UIKit

class LoginView: UIViewController {

	@IBOutlet var usernameLbl: UITextField!
	@IBOutlet var passwordLbl: UITextField!
	lazy var alerMang = AlertsManager()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		usernameLbl.text = ""
		usernameLbl.text = ""
    }
    
	// MARK: - Navigation
	@IBAction func loginBtnTapped(_ sender: Any) {
		
		if isLoginValid(for: usernameLbl.text!, and: passwordLbl.text!){
			let tabsController = storyboard?.instantiateViewController(withIdentifier: "TabsMainController") as! TabsMainController
			tabsController.selectedViewController = tabsController.viewControllers?[0]
			present(tabsController, animated: true, completion: nil)
		}
	}
	
	private func isLoginValid(for username: String, and password: String) -> Bool {
		if username.isEmpty || password.isEmpty {
			alerMang.showLoginAlert(from: self, alertTitle: "Invalid Login", saying: "Username or password can't be empty, Try again.", actionTitle: "OK")
			return false
		}
		if !username.contains("@") {
			alerMang.showLoginAlert(from: self, alertTitle: "Invalid email", saying: "Invalid email address, Try again.", actionTitle: "OK")
			return false
		}
		
		if password != "password" {
			alerMang.showLoginAlert(from: self, alertTitle: "Invalid Credentials", saying: "Your username or password is invalid. Try again.", actionTitle: "OK")
			return false
		}
		return true
	}

}
