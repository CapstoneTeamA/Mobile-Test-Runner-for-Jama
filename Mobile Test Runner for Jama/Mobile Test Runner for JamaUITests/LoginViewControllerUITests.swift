//
//  LoginViewControllerUITests.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/27/17.
//  Copyright © 2017 Jaca. All rights reserved.
//


import XCTest

class LoginViewControllerUITests: XCTestCase {
    let app = XCUIApplication()
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoginExists() {
        XCTAssert(app.staticTexts["Login"].exists)
    }
    
    func testUsernamePlaceholder() {
        let usernameTextField = app.textFields["Username"]
        XCTAssertEqual(usernameTextField.placeholderValue, "Username")
        
    }
    
    func testPasswordPlaceholder() {
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertEqual(passwordSecureTextField.placeholderValue, "Password")
    }
    
    func testInstancePlaceholder() {
        let jamaInstanceTextField = app.textFields["Jama-Instance"]
        XCTAssertEqual(jamaInstanceTextField.placeholderValue, "Jama-Instance")
    }
    
    func testLogInPlaceHolder() {
        let logInButton = app.buttons["Log In"]
        XCTAssertEqual(logInButton.label, "Log In")
        
    }
    func testRequiredFields() {
        let logInButton = app.buttons["Log In"]
        logInButton.tap()
        _ = XCUIApplication().staticTexts["One or more required fields were not entered."]
        XCTAssert(app.staticTexts["One or more required fields were not entered."].exists)
    }
    
    func testInvalidLogin() {
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        app.textFields["Username"].typeText("username")
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("bad_password")
        let jamaInstanceTextField = app.textFields["Jama-Instance"]
        jamaInstanceTextField.tap()
        app.textFields["Jama-Instance"].typeText("capstone-sandbox")
        let logInButton = app.buttons["Log In"]
        logInButton.tap()
        let invalidLoginLabel = app.staticTexts["Your login attempt was not successful. The user credentials you entered were not valid, please try again."]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: invalidLoginLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
