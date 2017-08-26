//
//  UserModelUnitTest.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import XCTest
@testable import Mobile_Test_Runner_for_Jama

class UserModelUnitTest: XCTestCase {
    var user = UserModel()
    var userData : [String : AnyObject] = [:]
    var firstName = "tester"
    var lastName = "McTester"
    var email = "tester@jaca.com"
    var username = "McT"
    var licenseType = "NAMED"
    var id = 23
    
    override func setUp() {
        super.setUp()
        
        userData.updateValue(firstName as AnyObject, forKey: "firstName")
        userData.updateValue(lastName as AnyObject, forKey: "lastName")
        userData.updateValue(email as AnyObject, forKey: "email")
        userData.updateValue(id as AnyObject, forKey: "id")
        userData.updateValue(username as AnyObject, forKey: "username")
        userData.updateValue(licenseType as AnyObject, forKey: "licenseType")
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExtractUserFromData() {
        user.extractUser(fromData: userData)
        
        XCTAssertEqual(firstName, user.firstName)
        XCTAssertEqual(lastName, user.lastName)
        XCTAssertEqual(email, user.email)
        XCTAssertEqual(username, user.username)
        XCTAssertEqual(id, user.id)
        XCTAssertEqual(licenseType, user.licenseType)
    }
    
    func testExtractUserFromEmptyData() {
        user.extractUser(fromData: [:])
        
        XCTAssertTrue(user.firstName.isEmpty)
        XCTAssertTrue(user.lastName.isEmpty)
        XCTAssertTrue(user.email.isEmpty)
        XCTAssertTrue(user.username.isEmpty)
        XCTAssertTrue(user.licenseType.isEmpty)
        XCTAssertEqual(-1, user.id)
    }
    
    
}
