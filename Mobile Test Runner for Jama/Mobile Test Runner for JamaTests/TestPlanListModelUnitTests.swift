//
//  TestPlanListModelUnitTests.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import XCTest
@testable import Mobile_Test_Runner_for_Jama
class TestPlanListModelUnitTests: XCTestCase {
    var planList = TestPlanListModel()
    var plan1 = TestPlanModel()
    var plan2 = TestPlanModel()
    var fields1: [String : AnyObject] = [:]
    var fields2: [String : AnyObject] = [:]
    var plan1Data: [String : AnyObject] = [:]
    var plan2Data: [String : AnyObject] = [:]
    var id1 = 1
    var id2 = 2
    var projectId = 123
    var plan1Name = "plan1"
    var plan2Name = "plan2"
    var testPlanType = 35
    var notTestPlanType = 36
    var data: [[String : AnyObject]] = []
    
    override func setUp() {
        super.setUp()
        plan1.id = id1
        plan2.id = id2
        plan1.projectId = projectId
        plan2.projectId = projectId
        plan1.name = plan1Name
        plan2.name = plan2Name
        
        fields1.updateValue(plan1Name as AnyObject, forKey: "name")
        plan1Data.updateValue(id1 as AnyObject, forKey: "id")
        plan1Data.updateValue(projectId as AnyObject, forKey: "project")
        plan1Data.updateValue(fields1 as AnyObject, forKey: "fields")
        plan1Data.updateValue(testPlanType as AnyObject, forKey: "itemType")
        plan1Data.updateValue(false as AnyObject, forKey: "archived")
        
        fields2.updateValue(plan2Name as AnyObject, forKey: "name")
        plan2Data.updateValue(id2 as AnyObject, forKey: "id")
        plan2Data.updateValue(projectId as AnyObject, forKey: "project")
        plan2Data.updateValue(fields2 as AnyObject, forKey: "fields")
        plan2Data.updateValue(testPlanType as AnyObject, forKey: "itemType")
        plan2Data.updateValue(false as AnyObject, forKey: "archived")
        
        data.append(plan1Data)
        data.append(plan2Data)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExtractTestPlanFromEmptyData() {
        planList.extractPlanList(fromData: [])
        
        XCTAssertTrue(planList.testPlanList.isEmpty)
    }
    
    func testExtractPlanList() {
        planList.extractPlanList(fromData: data)
        
        XCTAssertEqual(plan1.id, planList.testPlanList[0].id)
        XCTAssertEqual(plan1.projectId, planList.testPlanList[0].projectId)
        XCTAssertEqual(plan1.name, planList.testPlanList[0].name)
        XCTAssertEqual(plan2.id, planList.testPlanList[1].id)
        XCTAssertEqual(plan2.projectId, planList.testPlanList[1].projectId)
        XCTAssertEqual(plan2.name, planList.testPlanList[1].name)
    }
    
    func testExtractTestPlanFromWrongItemTypeData() {
        plan1Data.updateValue(notTestPlanType as AnyObject, forKey: "itemType")
        plan2Data.updateValue(notTestPlanType as AnyObject, forKey: "itemType")
        
        data = []
        data.append(plan1Data)
        data.append(plan2Data)
        
        XCTAssertTrue(planList.testPlanList.isEmpty)
    }
}
