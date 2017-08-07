//
//  TestCycleModelUnitTests.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import XCTest
@testable import Mobile_Test_Runner_for_Jama
class TestCycleModelUnitTests: XCTestCase {
    var data: [String: AnyObject] = [:]
    var testCycle = TestCycleModel()
    override func setUp() {
        super.setUp()
        var fields: [String : AnyObject] = [:]
        fields.updateValue("cycle1" as AnyObject, forKey: "name")
        data.updateValue(2323 as AnyObject, forKey: "id")
        data.updateValue(fields as AnyObject, forKey: "fields")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExtractCycleFromData() {
        testCycle.extractCycle(fromData: data)
        
        XCTAssertEqual(2323, testCycle.id)
        XCTAssertEqual("cycle1", testCycle.name)
    }
}
