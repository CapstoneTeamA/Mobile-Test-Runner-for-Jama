//
//  TestCycleListModelUnitTests.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import XCTest
@testable import Mobile_Test_Runner_for_Jama
class TestCycleListModelUnitTests: XCTestCase {
    var cycleList = TestCycleListModel()
    var cycle1 = TestCycleModel()
    var cycle2 = TestCycleModel()
    var fields1: [String : AnyObject] = [:]
    var fields2: [String : AnyObject] = [:]
    var cycle1Data: [String : AnyObject] = [:]
    var cycle2Data: [String : AnyObject] = [:]
    var id1 = 1
    var id2 = 2
    var projectId = 123
    var cycle1Name = "cycle1"
    var cycle2Name = "cycle2"
    var data: [[String : AnyObject]] = []
    
    override func setUp() {
        super.setUp()
        cycle1.id = id1
        cycle2.id = id2
        cycle1.name = cycle1Name
        cycle2.name = cycle2Name
        
        fields1.updateValue(cycle1Name as AnyObject, forKey: "name")
        cycle1Data.updateValue(id1 as AnyObject, forKey: "id")
        cycle1Data.updateValue(fields1 as AnyObject, forKey: "fields")
        
        fields2.updateValue(cycle2Name as AnyObject, forKey: "name")
        cycle2Data.updateValue(id2 as AnyObject, forKey: "id")
        cycle2Data.updateValue(fields2 as AnyObject, forKey: "fields")
        
        data.append(cycle1Data)
        data.append(cycle2Data)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExtractTestCycleFromEmptyData() {
        cycleList.extractCycleList(fromData: [])
        
        XCTAssertTrue(cycleList.testCycleList.isEmpty)
    }
    
    func testExtractCycleList() {
        cycleList.extractCycleList(fromData: data)
        
        XCTAssertEqual(cycle1.id, cycleList.testCycleList[0].id)
        XCTAssertEqual(cycle1.name, cycleList.testCycleList[0].name)
        XCTAssertEqual(cycle2.id, cycleList.testCycleList[1].id)
        XCTAssertEqual(cycle2.name, cycleList.testCycleList[1].name)
    }
}
