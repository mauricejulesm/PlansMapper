//
//  PlansMapperUITests.swift
//  PlansMapperUITests
//
//  Created by falcon on 12/8/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import XCTest

class PlansMapperUITests: XCTestCase {
	var testPlanTitle = ""
	var testPlanDesc = ""
	
	
    override func setUp() {
		testPlanTitle = "Test title: Buy shoes"
		testPlanDesc = "Test Description pass by the store and by sneakers"
		
        // To stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test.
        XCUIApplication().launch()
    }
	
	func testPlansTableLoad() {
		
		let app = XCUIApplication()
		let tablesQuery = app.tables
		tablesQuery.cells.containing(.staticText, identifier:"Buy shoes").element.swipeLeft()
		tablesQuery.cells.containing(.staticText, identifier:"Buy shoes").element.swipeRight()
		let shoppingTable = app/*@START_MENU_TOKEN@*/.tables.containing(.other, identifier:"SHOPPING").element/*[[".tables.containing(.other, identifier:\"COMPLETED\").element",".tables.containing(.other, identifier:\"OTHER\").element",".tables.containing(.other, identifier:\"FOOD\").element",".tables.containing(.other, identifier:\"SPORTS\").element",".tables.containing(.other, identifier:\"SHOPPING\").element"],[[[-1,4],[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		shoppingTable.swipeDown()
		shoppingTable.swipeUp()
    }
	
	func testCreateNewPlan() {
		
		let app = XCUIApplication()
		app.navigationBars["Plans List"].buttons["Add"].tap()
		
		let newPlanTitle = app.textFields["Enter new plan here"]
		XCTAssert(newPlanTitle.exists)
		newPlanTitle.tap()
		newPlanTitle.typeText(testPlanTitle)

		let textView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
		XCTAssert(textView.exists)
		textView.tap()
		textView.typeText(testPlanDesc)
		
		let dayMonthYearTextField = app.textFields["Day/Month/Year"]
		dayMonthYearTextField.tap()
		
		let doneButton = app.toolbars["Toolbar"].buttons["Done"]
		doneButton.tap()
		
		let saveButton = app.navigationBars["New Plan"].buttons["Save"]
		saveButton.tap()
		
		XCUIApplication().tables.staticTexts[testPlanTitle].swipeUp()
		
	}

	
	func testPlansMapLoad() {
		let app = XCUIApplication()
		
		let tablesQuery = app.tables
		tablesQuery.staticTexts["Buy shoes"].swipeRight()
		tablesQuery.buttons["Go"].tap()
		
		let theMap = app.maps.element
		theMap.swipeDown()
		theMap.swipeLeft()
		theMap.swipeRight()
		app.tabBars.buttons["Plans"].tap()
		tablesQuery.staticTexts["Buy shoes"].swipeDown()
		
	}
	
	func testEditPlan(){
		let testEditedTitle = "Test P edited title"
		let testEditedPlanDesc = "Test edited  Description"
		
		let app = XCUIApplication()
		
		let tablesQuery = app.tables
		tablesQuery.staticTexts[testPlanTitle].swipeLeft()
		tablesQuery.buttons["Edit"].tap()
		
		let newPlanTitle = app.textFields["Enter new plan here"]
		XCTAssert(newPlanTitle.exists)
		newPlanTitle.tap()
		newPlanTitle.clearAndEnterText(text: testEditedTitle)

		let textView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
		XCTAssert(textView.exists)
		textView.tap()
		textView.clearAndEnterText(text: testEditedPlanDesc)

		let dayMonthYearTextField = app.textFields["Day/Month/Year"]
		dayMonthYearTextField.tap()
		
		let doneButton = app.toolbars["Toolbar"].buttons["Done"]
		doneButton.tap()
		
		let saveButton = app.navigationBars["New Plan"].buttons["Save"]
		saveButton.tap()
		
		XCUIApplication().tables.staticTexts[testEditedTitle].swipeUp()
		
	}
	
	

}

extension XCUIElement {
	
	func clearAndEnterText(text: String) {
		guard let stringValue = self.value as? String else {
			XCTFail("Tried to clear and enter text into a non string value")
			return
		}
		
		self.tap()
		
		let deleteString = stringValue.map { _ in "\u{8}" }.joined(separator: "")
		
		self.typeText(deleteString)
		self.typeText(text)
	}
	
}
