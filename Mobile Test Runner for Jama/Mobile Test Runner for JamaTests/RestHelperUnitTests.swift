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
    let encodedUserInfo = "dGVzdGVyOnBhc3N3b3Jk" //64bit encoding of "tester:password"
    
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
    
    func testPrepareHttpRequest() {
        let endpoint = "endpoint.com"
        let url = URL(string: endpoint)
        let result = RestHelper.prepareHttpRequest(atEndpointString: endpoint, username: username, password: password, httpMethod: "Get")
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic " + encodedUserInfo, forHTTPHeaderField: "Authorization")
        request.httpMethod = "Get"
        
        XCTAssertEqual(result, request)
    }
    
    func testPrepareHttpRequestFails() {
        let endpoint = ""
        let result = RestHelper.prepareHttpRequest(atEndpointString: endpoint, username: username, password: password, httpMethod: "Get")
        XCTAssertNil(result)
    }
    
    func testProcessRestJson() {
        var jsonData: [String: Any] = [:]
        let parsedData: [String : AnyObject] = ["name" : username as AnyObject]

        jsonData.updateValue(["status" : "status"], forKey: "meta")
        jsonData.updateValue(parsedData, forKey: "data")
        
        let result = RestHelper.processRestJson(jsonData: jsonData)
        let resultNameValue: String = result.0[0]["name"] as! String
        XCTAssertEqual(resultNameValue, username)
    }
    
    func testProcessRestJsonUnauthorized() {
        var jsonData: [String: Any] = [:]

        jsonData.updateValue(["status" : "Unauthorized"], forKey: "meta")
        jsonData.updateValue("", forKey: "data")
        
        let result = RestHelper.processRestJson(jsonData: jsonData)
        let resultNameValue: String = result.0[0]["Unauthorized"] as! String
        XCTAssertEqual(resultNameValue, "Unauthorized")
    }
    
}

