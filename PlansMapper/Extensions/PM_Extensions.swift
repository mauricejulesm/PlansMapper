//
//  PM_Extensions.swift
//  PlansMapper
//
//  Created by falcon on 11/9/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//
import UIKit

//MARK: - UI COLOR
extension UIColor {
	public convenience init?(hex: String) {
		let r, g, b, a: CGFloat
		
		if hex.hasPrefix("#") {
			let start = hex.index(hex.startIndex, offsetBy: 1)
			let hexColor = String(hex[start...])
			
			if hexColor.count == 8 {
				let scanner = Scanner(string: hexColor)
				var hexNumber: UInt64 = 0
				
				if scanner.scanHexInt64(&hexNumber) {
					r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
					g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
					b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
					a = CGFloat(hexNumber & 0x000000ff) / 255
					
					self.init(red: r, green: g, blue: b, alpha: a)
					return
				}
			}
		}
		
		return nil
	}
	
	var pmMainBlackBackground : UIColor {
		return UIColor (hex: "#16191e")!
	}
	
	var pmMainDarkYellow : UIColor {
		return UIColor (hex: "#cfa670")!
	}
	
	var mycolor : UIColor {
		return #colorLiteral(red: 0.8117647059, green: 0.6509803922, blue: 0.4392156863, alpha: 1)
	}
	
	
	
}

//MARK: - UI FONT

