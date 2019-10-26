//
//  NewPlanView.swift
//  PlansMapper
//
//  Created by falcon on 10/26/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import UIKit

class NewPlanView: UIViewController {

	@IBOutlet var txtFieldNewPlanTitle: UITextField!
	@IBOutlet var txtFldDeadline: UITextField!
	override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "New Plan"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
