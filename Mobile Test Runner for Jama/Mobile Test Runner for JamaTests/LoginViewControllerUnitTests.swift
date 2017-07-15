//
//  LoginViewControllerUnitTests.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import XCTest
@testable import Mobile_Test_Runner_for_Jama
class LoginViewControllerUnitTests: XCTestCase {
    let userFirstName = "tester"
    let userLastName = "Mctester"
    let userId = 23
    let userEmail = "tester@jaca.com"
    let username = "T_McT"
    let password = "dumb_password"
    let instance = "jaca_instance"
    let missingFieldError = "One or more required fields were not entered."
    var viewController : LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    var userData : [String : AnyObject] = [:]
    
    override func setUp() {
        super.setUp()
        _ = viewController.view //Needed to instantiate the properties in the class
        userData.updateValue(userFirstName as AnyObject, forKey: "firstName")
        userData.updateValue(userLastName as AnyObject, forKey: "lastName")
        userData.updateValue(userId as AnyObject, forKey: "id")
        userData.updateValue(username as AnyObject, forKey: "username")
        userData.updateValue(userEmail as AnyObject, forKey: "email")
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReloadViewWithUsernameAndInstanceSaved() {
        viewController.userNameTextBox.text = username
        viewController.passwordTextBox.text = password
        viewController.instanceTextBox.text = instance
        
        viewController.reloadViewWithUsernameAndInstanceSaved()
        
        XCTAssertEqual(username, viewController.userNameTextBox.text)
        XCTAssertEqual(instance, viewController.instanceTextBox.text)
        XCTAssertEqual("", viewController.passwordTextBox.text)
    }
    
    func testReloadViewErrorAppears() {
        viewController.unauthorizedLabel.isHidden = true
        
        viewController.reloadViewWithUsernameAndInstanceSaved()
        
        XCTAssertFalse(viewController.unauthorizedLabel.isHidden)
    }
    
    func testMissingAllFields() {
        XCTAssertFalse(viewController.checkRequiredFieldsNotEmpty())
        XCTAssertEqual(viewController.unauthorizedLabel.text, missingFieldError)
        XCTAssertFalse(viewController.unauthorizedLabel.isHidden)
    }
    
    func testMissingUsername() {
        viewController.passwordTextBox.text = password
        viewController.instanceTextBox.text = instance
        
        XCTAssertFalse(viewController.checkRequiredFieldsNotEmpty())
        XCTAssertEqual(viewController.unauthorizedLabel.text, missingFieldError)
        XCTAssertFalse(viewController.unauthorizedLabel.isHidden)
    }
    
    func testMisssingPassword() {
        viewController.userNameTextBox.text = username
        viewController.instanceTextBox.text = instance
        
        XCTAssertFalse(viewController.checkRequiredFieldsNotEmpty())
        XCTAssertEqual(viewController.unauthorizedLabel.text, missingFieldError)
        XCTAssertFalse(viewController.unauthorizedLabel.isHidden)
    }
    
    func testMissingInstance() {
        viewController.userNameTextBox.text = username
        viewController.passwordTextBox.text = password
        
        XCTAssertFalse(viewController.checkRequiredFieldsNotEmpty())
        XCTAssertEqual(viewController.unauthorizedLabel.text, missingFieldError)
        XCTAssertFalse(viewController.unauthorizedLabel.isHidden)
    }
    
    func testMissingInstanceAndPassword() {
        viewController.userNameTextBox.text = username
        
        XCTAssertFalse(viewController.checkRequiredFieldsNotEmpty())
        XCTAssertEqual(viewController.unauthorizedLabel.text, missingFieldError)
        XCTAssertFalse(viewController.unauthorizedLabel.isHidden)
    }
    
    func testMissingInstanceAndUserName() {
        viewController.passwordTextBox.text = password
        
        XCTAssertFalse(viewController.checkRequiredFieldsNotEmpty())
        XCTAssertEqual(viewController.unauthorizedLabel.text, missingFieldError)
        XCTAssertFalse(viewController.unauthorizedLabel.isHidden)
    }
    
    func testMissingUsernameAndPassword() {
        viewController.instanceTextBox.text = instance
        
        XCTAssertFalse(viewController.checkRequiredFieldsNotEmpty())
        XCTAssertEqual(viewController.unauthorizedLabel.text, missingFieldError)
        XCTAssertFalse(viewController.unauthorizedLabel.isHidden)
    }
    
    func testNoMissingFields() {
        viewController.userNameTextBox.text = username
        viewController.passwordTextBox.text = password
        viewController.instanceTextBox.text = instance
        
        XCTAssertTrue(viewController.checkRequiredFieldsNotEmpty())
        XCTAssertNotEqual(viewController.unauthorizedLabel.text, missingFieldError)
        XCTAssertTrue(viewController.unauthorizedLabel.isHidden)
    }
    
    func testAuthErrorMessageHidesAfterLoad(){
        viewController.passwordTextBox.text = password
        
        XCTAssertFalse(viewController.checkRequiredFieldsNotEmpty())
        XCTAssertEqual(viewController.unauthorizedLabel.text, missingFieldError)
        XCTAssertFalse(viewController.unauthorizedLabel.isHidden)
        
        viewController.viewWillAppear(false)
        XCTAssertTrue(viewController.unauthorizedLabel.isHidden)
    }
}
