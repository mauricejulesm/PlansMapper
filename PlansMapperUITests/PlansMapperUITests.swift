//
//  PlansMapperUITests.swift
//  PlansMapperUITests
//
//  Created by falcon on 12/8/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import XCTest

class PlansMapperUITests: XCTestCase {

    override func setUp() {
        // To stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test.
        XCUIApplication().launch()
    }

	func testAppLaunch() {
		9353dd2
	}
	
    func testPlansTableLoad() {
		
		let app = XCUIApplication()
		app.navigationBars["Plans List"].buttons["Add"].tap()
		app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element.tap()
		
		let dayMonthYearTextField = app.textFields["Day/Month/Year"]
		dayMonthYearTextField.tap()
		dayMonthYearTextField.tap()
		
		
		app.toolbars["Toolbar"].buttons["Done"].tap()
		app.navigationBars["New Plan"].buttons["Save"].tap()
		
		
						
    }
	
	func testLoadPlansMap() {
		
		let app = XCUIApplication()
		app.tables/*@START_MENU_TOKEN@*/.staticTexts["Remember to go to the store after work"]/*[[".cells.staticTexts[\"Remember to go to the store after work\"]",".staticTexts[\"Remember to go to the store after work\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeRight()
		app.tabBars.buttons["Plans"].tap()
		
		
		
		
	}

	
	func testPlanStatusSwitch() {
		print("Changed Status")
	}

}
