//
//  ProjectPlanModelUnitTests.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import XCTest
@testable import Mobile_Test_Runner_for_Jama
class TestPlanModelUnitTests: XCTestCase {
    var data: [String: AnyObject] = [:]
    var testPlan = TestPlanModel()
    override func setUp() {
        super.setUp()
        var fields: [String : AnyObject] = [:]
        fields.updateValue("plan1" as AnyObject, forKey: "name")
        data.updateValue(2323 as AnyObject, forKey: "id")
        data.updateValue(23 as AnyObject, forKey: "project")
        data.updateValue(fields as AnyObject, forKey: "fields")
        data.updateValue(false as AnyObject, forKey: "archived")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExtractPlanFromData() {
        testPlan.extractPlan(fromData: data)
        
        XCTAssertEqual(2323, testPlan.id)
        XCTAssertEqual(23, testPlan.projectId)
        XCTAssertEqual("plan1", testPlan.name)
        XCTAssertEqual(false, testPlan.archived)
    }
}
