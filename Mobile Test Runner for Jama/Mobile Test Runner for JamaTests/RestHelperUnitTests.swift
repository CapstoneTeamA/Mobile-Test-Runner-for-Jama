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
    let username = "tester"
    let password = "password"
    var restData : [[String: AnyObject]] = []
    let encodedUserInfo = "dGVzdGVyOnBhc3N3b3Jk"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testBasicAuthRequest() {
        guard let url = URL(string: "pathToResource.jaca.com/rest/test") else {
            print("URL was not constructed")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic " + encodedUserInfo, forHTTPHeaderField: "Authorization")
        let returnedRequest = RestHelper.basicAuth(url: url, username: username, password: password)
        
        XCTAssertEqual(request, returnedRequest)
    }
    
    func testBasicAuthRequestFail() {
        guard let url = URL(string: "pathToResource.jaca.com/rest/test") else {
            print("URL was not constructed")
            return
        }
        
        //Create an auth string that is not the 64bit encoded username:password string.
        let badAuthString = encodedUserInfo + "SomeBadStuff"
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic " + badAuthString, forHTTPHeaderField: "Authorization")
        let returnedRequest = RestHelper.basicAuth(url: url, username: username, password: password)
        
        XCTAssertNotEqual(request, returnedRequest)
    }
    
    
}

