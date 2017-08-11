//
//  TestRunListModelUnitTests.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import XCTest
@testable import Mobile_Test_Runner_for_Jama
class TestRunListModelUnitTests: XCTestCase {
    let testRunList = TestRunListModel()
    var dataList: [[String : AnyObject]] = []
    var run1Data: [String : AnyObject] = [:]
    var run2Data: [String : AnyObject] = [:]
    var run1DataFields: [String : AnyObject] = [:]
    var run2DataFields: [String : AnyObject] = [:]
    var parentTestCycleId = 13
    var run1Name = "run1"
    var run2Name = "run2"
    var run1Id = 24
    var run2Id = 25
    var run1Desc = "desc1"
    var run2Desc = "desc2"
    var run1AssignedToId = 31
    var testRunItemType = 37
    var run1Status = "INPROGRESS"
    var run2Status = "NOT_RUN"
    
    override func setUp() {
        super.setUp()
        run1Data.updateValue(run1Id as AnyObject, forKey: "id")
        run1Data.updateValue(testRunItemType as AnyObject, forKey: "itemType")
        run2Data.updateValue(run2Id as AnyObject, forKey: "id")
        run2Data.updateValue(testRunItemType as AnyObject, forKey: "itemType")
        
        run1DataFields.updateValue(run1Name as AnyObject, forKey: "name")
        run1DataFields.updateValue(run1Desc as AnyObject, forKey: "description")
        run1DataFields.updateValue(run1AssignedToId as AnyObject, forKey: "assignedTo")
        run1DataFields.updateValue(parentTestCycleId as AnyObject, forKey: "testCycle")
        run1DataFields.updateValue(run1Status as AnyObject, forKey: "testRunStatus")
        
        run2DataFields.updateValue(run2Name as AnyObject, forKey: "name")
        run2DataFields.updateValue(run2Desc as AnyObject, forKey: "description")
        run2DataFields.updateValue(parentTestCycleId as AnyObject, forKey: "testCycle")
        run2DataFields.updateValue(run2Status as AnyObject, forKey: "testRunStatus")
        //Run 2 will not have an assignedTo to simulate an unassigned test run.
        
        run1Data.updateValue(run1DataFields as AnyObject, forKey: "fields")
        run2Data.updateValue(run2DataFields as AnyObject, forKey: "fields")
        
        dataList.append(run1Data)
        dataList.append(run2Data)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExtractEmptyDataList() {
        testRunList.extractRunList(fromData: [], parentId: parentTestCycleId)
        
        XCTAssertTrue(testRunList.testRunList.isEmpty)
    }
    
    func testExtractDataListFromWrongParentCycle() {
        testRunList.extractRunList(fromData: dataList, parentId: parentTestCycleId + 1)
        
        XCTAssertTrue(testRunList.testRunList.isEmpty)
    }
    
    func testExtractDataListFromWrongDataType() {
        dataList = []
        run1Data.updateValue(testRunItemType + 1 as AnyObject, forKey: "itemType")
        run2Data.updateValue(testRunItemType + 1 as AnyObject, forKey: "itemType")
        dataList.append(run1Data)
        dataList.append(run2Data)
        
        testRunList.extractRunList(fromData: dataList, parentId: parentTestCycleId)
        XCTAssertTrue(testRunList.testRunList.isEmpty)
    }
    
    func testExtractDataFromDataList() {
        testRunList.extractRunList(fromData: dataList, parentId: parentTestCycleId)
        
        XCTAssertEqual(dataList.count, testRunList.testRunList.count)
        XCTAssertEqual(run1Name, testRunList.testRunList[0].name)
        XCTAssertEqual(run1Id, testRunList.testRunList[0].id)
        XCTAssertEqual(run1Desc, testRunList.testRunList[0].description)
        XCTAssertEqual(run1AssignedToId, testRunList.testRunList[0].assignedTo)
        XCTAssertEqual(run1Status, testRunList.testRunList[0].testStatus)
        
        XCTAssertEqual(run2Name, testRunList.testRunList[1].name)
        XCTAssertEqual(run2Id, testRunList.testRunList[1].id)
        XCTAssertEqual(run2Desc, testRunList.testRunList[1].description)
        XCTAssertEqual(-1, testRunList.testRunList[1].assignedTo)
        XCTAssertEqual(run2Status, testRunList.testRunList[1].testStatus)
    }
}
