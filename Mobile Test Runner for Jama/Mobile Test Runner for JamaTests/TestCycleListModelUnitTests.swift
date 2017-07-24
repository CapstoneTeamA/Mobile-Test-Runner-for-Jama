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
    var testPlanId = 12
    var testCycleItemType = 36
    var notTestCycleItemType = 37
    var data: [[String : AnyObject]] = []
    
    override func setUp() {
        super.setUp()
        cycle1.id = id1
        cycle2.id = id2
        cycle1.name = cycle1Name
        cycle2.name = cycle2Name
        
        fields1.updateValue(testPlanId as AnyObject, forKey: "testPlan")
        fields1.updateValue(cycle1Name as AnyObject, forKey: "name")
        cycle1Data.updateValue(id1 as AnyObject, forKey: "id")
        cycle1Data.updateValue(fields1 as AnyObject, forKey: "fields")
        cycle1Data.updateValue(testCycleItemType as AnyObject, forKey: "itemType")
        
        fields2.updateValue(testPlanId as AnyObject, forKey: "testPlan")
        fields2.updateValue(cycle2Name as AnyObject, forKey: "name")
        cycle2Data.updateValue(id2 as AnyObject, forKey: "id")
        cycle2Data.updateValue(fields2 as AnyObject, forKey: "fields")
        cycle2Data.updateValue(testCycleItemType as AnyObject, forKey: "itemType")
        
        data.append(cycle1Data)
        data.append(cycle2Data)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExtractTestCycleFromEmptyData() {
        cycleList.extractCycleList(fromData: [], parentId: testPlanId)
        
        XCTAssertTrue(cycleList.testCycleList.isEmpty)
    }
    
    func testExtractCycleListFromWrongParentData() {
        cycleList.extractCycleList(fromData: data, parentId: testPlanId + 1)
        
        XCTAssertTrue(cycleList.testCycleList.isEmpty)
    }
    
    func testExtractCycleList() {
        cycleList.extractCycleList(fromData: data, parentId: testPlanId)
        
        XCTAssertEqual(cycle1.id, cycleList.testCycleList[0].id)
        XCTAssertEqual(cycle1.name, cycleList.testCycleList[0].name)
        XCTAssertEqual(cycle2.id, cycleList.testCycleList[1].id)
        XCTAssertEqual(cycle2.name, cycleList.testCycleList[1].name)
    }
    
    func testExtractCycleListFromWrongItemTypeData() {
        cycle1Data.updateValue(notTestCycleItemType as AnyObject, forKey: "itemType")
        cycle2Data.updateValue(notTestCycleItemType as AnyObject, forKey: "itemType")
        
        data = []
        data.append(cycle1Data)
        data.append(cycle2Data)
        
        cycleList.extractCycleList(fromData: data, parentId: testPlanId)
        
        XCTAssertTrue(cycleList.testCycleList.isEmpty)
    }
}
