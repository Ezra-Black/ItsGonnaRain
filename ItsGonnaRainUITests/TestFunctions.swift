//
//  TestFunctions.swift
//  ItsGonnaRainUITests
//
//  Created by Ezra Black on 12/28/21.
//

import XCTest
import Foundation

class TestFunctions: XCTestCase {
    let app = XCUIApplication()
    
    
    func homeLifeCycleTest() {
        let label = app.staticTexts.element(matching: .any, identifier: "current location label")
        let label2 = app.staticTexts.element(matching: .any, identifier: "current time label")
        let label3 = app.staticTexts.element(matching: .any, identifier: "curent temp label")
        let label4 = app.staticTexts.element(matching: .any, identifier: "temp details label")
        let label5 = app.staticTexts.element(matching: .any, identifier: "max temp label")
        let label6 = app.staticTexts.element(matching: .any, identifier: "min temp label")
        let collectionView = app.collectionViews.element(matching: .collectionView, identifier: "collectionView")
        XCTAssertTrue(label.exists)
        XCTAssertTrue(label2.exists)
        XCTAssertTrue(label3.exists)
        XCTAssertTrue(label4.exists)
        XCTAssertTrue(label5.exists)
        XCTAssertTrue(label6.exists)
        XCTAssertTrue(collectionView.exists)
    }
    
    func touchTesting() {
        app.swipeUp()
        app.swipeDown()
        app.swipeRight()
        app.swipeLeft(velocity: XCUIGestureVelocity(integerLiteral: 500))
        app.doubleTap()
    }
    
    func e2e() {
        let itsgonnarainMainviewNavigationBar = app.navigationBars["ItsGonnaRain.MainView"]
        itsgonnarainMainviewNavigationBar.buttons["refresh"].tap()
        itsgonnarainMainviewNavigationBar.buttons["add"].tap()
        app.typeText("Paris")
        app.alerts["Add City"].scrollViews.otherElements.buttons["Cancel"].tap()
    }
    
    func buttonValidation() {
        XCTAssert(XCUIApplication().navigationBars["ItsGonnaRain.MainView"].buttons["refresh"].exists)
        XCUIApplication().navigationBars["ItsGonnaRain.MainView"].buttons["refresh"].tap()
    }
}
