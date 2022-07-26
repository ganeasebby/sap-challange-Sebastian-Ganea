//
//  SAP_ChallangeUITests.swift
//  SAP ChallangeUITests
//
//  Created by Sebastian Ganea on 26.07.2022.
//

import XCTest

class SAP_ChallangeUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testShowingTheCollectionview() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let collectionviewButton = XCUIApplication()/*@START_MENU_TOKEN@*/.staticTexts["Go to collection"]/*[[".buttons[\"Go to collection\"].staticTexts[\"Go to collection\"]",".staticTexts[\"Go to collection\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(collectionviewButton.exists)
        collectionviewButton.tap()
        
    }

}
