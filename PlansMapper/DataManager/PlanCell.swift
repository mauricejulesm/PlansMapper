//
//  PlanCell.swift
//  PlansMapper
//
//  Created by maurice on 10/23/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import UIKit

class PlanCell: UITableViewCell {
	@IBOutlet weak var planTitleLbl: UILabel!
	@IBOutlet weak var planDescLbl: UILabel!
	@IBOutlet var dateCreatedLbl: UILabel!
	@IBOutlet var img: UIImageView!
	@IBOutlet var doneSwitch: UISwitch!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		setupCellUI()
    }
	
	func setupCellUI() {
		img.layer.cornerRadius = 8.0
		img.layer.masksToBounds = true
	}
    }
