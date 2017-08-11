//
//  TestRunUnitTests.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import XCTest
@testable import Mobile_Test_Runner_for_Jama
class TestRunUnitTests: XCTestCase {
    var dataWithAssignment: [String : AnyObject] = [:]
    var dataWithoutAssignment: [String : AnyObject] = [:]
    var dataWithoutResult: [String : AnyObject] = [:]
    var dataWithResult: [String : AnyObject] = [:]
    var fields: [String : AnyObject] = [:]
    let run = TestRunModel()
    
    override func setUp() {
        super.setUp()
        dataWithAssignment.updateValue(23 as AnyObject, forKey: "id")
        dataWithoutAssignment.updateValue(23 as AnyObject, forKey: "id")
        dataWithResult.updateValue(23 as AnyObject, forKey: "id")
        dataWithoutResult.updateValue(23 as AnyObject, forKey: "id")
        
        fields.updateValue("testRun" as AnyObject, forKey: "name")
        fields.updateValue("desc" as AnyObject, forKey: "description")
        fields.updateValue("NOT_RUN" as AnyObject, forKey: "testRunStatus")
        dataWithoutAssignment.updateValue(fields as AnyObject, forKey: "fields")
        
        fields.updateValue(19 as AnyObject, forKey: "assignedTo")
        dataWithAssignment.updateValue(fields as AnyObject, forKey: "fields")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExtractRunFromDataWithoutAssignment() {
        run.extractRun(fromData: dataWithoutAssignment)
        
        XCTAssertEqual("testRun", run.name)
        XCTAssertEqual(23, run.id)
        XCTAssertEqual("desc", run.description)
        XCTAssertEqual(-1, run.assignedTo)
        XCTAssertEqual("NOT_RUN", run.testStatus)
    }
    
    func testExtractRunFromDataWithAssignment() {
        fields.updateValue(19 as AnyObject, forKey: "assignedTo")
        dataWithAssignment.updateValue(fields as AnyObject, forKey: "fields")
        run.extractRun(fromData: dataWithAssignment)
        
        XCTAssertEqual("testRun", run.name)
        XCTAssertEqual(23, run.id)
        XCTAssertEqual("desc", run.description)
        XCTAssertEqual(19, run.assignedTo)
    }
    
    func testExtractRunFromDataWithActualResults() {
        fields.updateValue("result for run" as AnyObject, forKey: "actualResults")
        dataWithResult.updateValue(fields as AnyObject, forKey: "fields")
        
        run.extractRun(fromData: dataWithResult)
        
        XCTAssertEqual("testRun", run.name)
        XCTAssertEqual(23, run.id)
        XCTAssertEqual("desc", run.description)
        XCTAssertEqual("result for run", run.result)
    }
    
    func testExtractRunFromDataWithoutActualResult() {
        dataWithoutResult.updateValue(fields as AnyObject, forKey: "fields")
        run.extractRun(fromData: dataWithoutResult)
        
        XCTAssertEqual("testRun", run.name)
        XCTAssertEqual(23, run.id)
        XCTAssertEqual("desc", run.description)
        XCTAssertEqual("", run.result)
    }
}
