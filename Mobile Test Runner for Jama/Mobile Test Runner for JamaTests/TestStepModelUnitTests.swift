//
//  TestStepModelUnitTests.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import XCTest
@testable import Mobile_Test_Runner_for_Jama
class TestStepModelUnitTests: XCTestCase {
    var fields: [String: AnyObject] = [:]
    var testModel = TestStepModel()
    
    override func setUp() {
        super.setUp()
        fields.updateValue("action" as AnyObject, forKey: "action")
        fields.updateValue("expResult" as AnyObject, forKey: "expectedResult")
        fields.updateValue("note" as AnyObject, forKey: "notes")
        fields.updateValue("result" as AnyObject, forKey: "result")
        fields.updateValue("pass" as AnyObject, forKey: "status")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExtractStepFromData() {
        testModel.extractStep(fromData: fields)
        
        XCTAssertEqual("action", testModel.action)
        XCTAssertEqual("expResult", testModel.expectedResult)
        XCTAssertEqual("note", testModel.notes)
        XCTAssertEqual("result", testModel.result)
        XCTAssertEqual("pass", testModel.status)
    }
}
