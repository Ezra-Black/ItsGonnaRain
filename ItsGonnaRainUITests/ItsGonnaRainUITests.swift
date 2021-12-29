//
//  ItsGonnaRainUITests.swift
//  ItsGonnaRainUITests
//
//  Created by Ezra Black on 7/05/21.
//

import XCTest

class ItsGonnaRainUITests: XCTestCase {
    
    let app = XCUIApplication()
    private var testObjects: TestObjects?
    private var testFunctions: TestFunctions?
    
    override func setUpWithError() throws {
        app.launch()
        testObjects = TestObjects()
        testFunctions = TestFunctions()
        continueAfterFailure = false
    }
    
    func testHomeScreen() throws {
        testFunctions?.homeLifeCycleTest()
    }
    
    
    func testButton() throws {
        testFunctions?.buttonValidation()
    }
    
    func testSimpleLifecycle() throws {
        testFunctions?.e2e()
    }
    
    func testTouch() throws {
        testFunctions?.touchTesting()
    }
}
