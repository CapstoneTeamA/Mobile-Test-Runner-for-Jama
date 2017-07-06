//
//  RestHelperUnitTests.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import XCTest
@testable import Mobile_Test_Runner_for_Jama

class RestHelperUnitTests: XCTestCase {
 

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetCurrentUserEndpoint() {
        let result = RestHelper.getEndpointString(method: "Get", endpoint: "CurrentUser")
        
        XCTAssertEqual(result, "jamacloud.com/rest/latest/users/current")
    }
    
    func testGetEndpointNotFound() {
        let result = RestHelper.getEndpointString(method: "Get", endpoint: "JacasFakeEndpoint")
        
        XCTAssertEqual(result, "")
    }
    
    func testGetEndpointBadMethodName() {
        let result = RestHelper.getEndpointString(method: "BadMethodName", endpoint: "jamacloud.com/rest/latest/users/current")
        
        XCTAssertEqual(result, "")
    }
    
    func testGetEndpointBadEndpointAndMethodName() {
        let result = RestHelper.getEndpointString(method: "BadMethodName", endpoint: "BadFakeEndpoint")
        
        XCTAssertEqual(result, "")
    }
}
