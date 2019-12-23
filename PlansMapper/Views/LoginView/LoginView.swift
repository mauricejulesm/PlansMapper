//
//  LoginView.swift
//  PlansMapper
//
//  Created by falcon on 12/23/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import UIKit

class LoginView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	// MARK: - Navigation
	@IBAction func loginBtnTapped(_ sender: Any) {
		let tabsController = storyboard?.instantiateViewController(withIdentifier: "TabsMainController") as! TabsMainController
		tabsController.selectedViewController = tabsController.viewControllers?[0]
		present(tabsController, animated: true, completion: nil)
		
	}

}
