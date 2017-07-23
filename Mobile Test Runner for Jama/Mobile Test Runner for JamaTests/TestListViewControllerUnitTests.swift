//
//  TestRunListViewControllerUnitTests.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import XCTest
@testable import Mobile_Test_Runner_for_Jama
class TestListViewControllerUnitTests: XCTestCase {
    let projectId = 23314
    let planId = 31132
    var viewController : TestListViewController!
    let instance = "test-instance"
    
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TestList") as! TestListViewController
        _ = viewController.view
        viewController.projectId = projectId
        viewController.instance = instance
        viewController.planId = planId
        
        let testPlan1 = TestPlanModel()
        let testPlan2 = TestPlanModel()
        let testCycle = TestCycleModel()
        
        testPlan1.id = 23
        testPlan1.name = "testPlan1"
        testPlan1.projectId = 2
        testPlan1.numOfCycles = 0
        testPlan2.id = 31
        testPlan2.name = "testPlan2"
        testPlan2.projectId = 2
        testPlan2.numOfCycles = 1
        
        testCycle.id = 123
        testCycle.name = "testCycle"
        viewController.totalCyclesVisable = 1
        viewController.selectedPlanIndex = 1
        viewController.testPlanList.testPlanList.append(testPlan1)
        viewController.testPlanList.testPlanList.append(testPlan2)
        viewController.testCycleList.testCycleList.append(testCycle)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBuildEndpointString() {
        let endpointString = viewController.buildTestPlanEndpointString()
        
        XCTAssertEqual("https://test-instance.jamacloud.com/rest/latest/testplans?project=23314", endpointString)
    }
    
    func testBuildTestCycleEndpointString() {
        viewController.planId = 45
        let endpointString = viewController.buildTestCycleEndpointString()

        XCTAssertEqual("https://test-instance.jamacloud.com/rest/latest/testplans/45/testcycles", endpointString)
    }
    
    func testComparePlan() {
        let plan1 = TestPlanModel()
        let plan2 = TestPlanModel()
        
        plan1.name = "aaa"
        plan2.name = "bbb"
        XCTAssertTrue(viewController.comparePlans(lhs: plan1, rhs: plan2))
        XCTAssertFalse(viewController.comparePlans(lhs: plan2, rhs: plan1))
        XCTAssertFalse(viewController.comparePlans(lhs: plan1, rhs: plan1))
        
        plan1.name = "AAA"
        XCTAssertTrue(viewController.comparePlans(lhs: plan1, rhs: plan2))
        XCTAssertFalse(viewController.comparePlans(lhs: plan2, rhs: plan1))
        XCTAssertFalse(viewController.comparePlans(lhs: plan1, rhs: plan1))
        
        plan1.name = "111"
        XCTAssertTrue(viewController.comparePlans(lhs: plan1, rhs: plan2))
        XCTAssertFalse(viewController.comparePlans(lhs: plan2, rhs: plan1))
        XCTAssertFalse(viewController.comparePlans(lhs: plan1, rhs: plan1))
        
        plan2.name = "000"
        XCTAssertTrue(viewController.comparePlans(lhs: plan2, rhs: plan1))
        XCTAssertFalse(viewController.comparePlans(lhs: plan1, rhs: plan2))
        XCTAssertFalse(viewController.comparePlans(lhs: plan1, rhs: plan1))
        
    }
    
    func testBuildCell() {

        let font = UIFont(name: "Helvetica Neue", size: 20.0)
        let white = UIColor.white
        let gray = UIColor(colorLiteralRed: 0xF5/0xFF, green: 0xF5/0xFF, blue: 0xF5/0xFF, alpha: 1)
        var cell = viewController.buildCell(indexPath: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual("testPlan1", cell.textLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.textLabel?.textAlignment)
        XCTAssertEqual(0, cell.indentationLevel)
        XCTAssertEqual(font, cell.textLabel?.font)
        XCTAssertEqual("TestPlanCell", cell.reuseIdentifier)
        XCTAssertEqual(white, cell.backgroundColor)
        
        cell = viewController.buildCell(indexPath: IndexPath(row: 1, section: 0))
        
        XCTAssertEqual("testPlan2", cell.textLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.textLabel?.textAlignment)
        XCTAssertEqual(0, cell.indentationLevel)
        XCTAssertEqual(font, cell.textLabel?.font)
        XCTAssertEqual("TestPlanCell", cell.reuseIdentifier)
        XCTAssertEqual(white, cell.backgroundColor)
        
        cell = viewController.buildCell(indexPath: IndexPath(row: 2, section: 0))
        
        XCTAssertEqual("testCycle", cell.textLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.textLabel?.textAlignment)
        XCTAssertEqual(1, cell.indentationLevel)
        XCTAssertEqual(font, cell.textLabel?.font)
        XCTAssertEqual("TestCycleCell", cell.reuseIdentifier)
        XCTAssertEqual(gray, cell.backgroundColor)
        
        viewController.testPlanList.testPlanList = viewController.testPlanList.testPlanList.reversed()
        viewController.selectedPlanIndex = 0
        cell = viewController.buildCell(indexPath: IndexPath(row: 1, section: 0))
        
        XCTAssertEqual("testCycle", cell.textLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.textLabel?.textAlignment)
        XCTAssertEqual(1, cell.indentationLevel)
        XCTAssertEqual(font, cell.textLabel?.font)
        XCTAssertEqual("TestCycleCell", cell.reuseIdentifier)
        XCTAssertEqual(gray, cell.backgroundColor)
        
        cell = viewController.buildCell(indexPath: IndexPath(row: 2, section: 0))
        XCTAssertEqual("testPlan1", cell.textLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.textLabel?.textAlignment)
        XCTAssertEqual(0, cell.indentationLevel)
        XCTAssertEqual(font, cell.textLabel?.font)
        XCTAssertEqual("TestPlanCell", cell.reuseIdentifier)
        XCTAssertEqual(white, cell.backgroundColor)
    }
    
    func testDidLoadEndpointEmptyPlanList() {
        viewController.currentTestLevel = .plan
        viewController.testPlanList.testPlanList = []
        viewController.didLoadEndpoint(data: [], totalItems: 0)
        XCTAssertTrue(viewController.testPlanList.testPlanList.isEmpty)
    }
    
    func testDidLoadEndpointEmptyCycleList() {
        viewController.currentTestLevel = .cycle
        viewController.testCycleList.testCycleList = []
        viewController.didLoadEndpoint(data: [], totalItems: 0)
        XCTAssertTrue(viewController.testCycleList.testCycleList.isEmpty)
    }
    
    func testDidLoadEndpointNilList() {
        viewController.currentTestLevel = .plan
        viewController.testPlanList.testPlanList = []
        viewController.didLoadEndpoint(data: nil, totalItems: 0)
        XCTAssertTrue(viewController.testPlanList.testPlanList.isEmpty)
    }
    
    func testDidEndpointLoadWithPlanData() {
        viewController.currentTestLevel = .plan
        viewController.testPlanList.testPlanList = []
        
        var dataList: [[String : AnyObject]] = []
        var planData: [String : AnyObject] = [:]
        var fields: [String : AnyObject] = [:]
        planData.updateValue(23 as AnyObject, forKey: "id")
        planData.updateValue(1 as AnyObject, forKey: "project")
        planData.updateValue(35 as AnyObject, forKey: "itemType")
        fields.updateValue("testPlan" as AnyObject, forKey: "name")
        planData.updateValue(fields as AnyObject, forKey: "fields")
        
        dataList.append(planData)
        
        viewController.didLoadEndpoint(data: dataList, totalItems: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            XCTAssertEqual("testPlan", self.viewController.testPlanList.testPlanList[0].name)
            XCTAssertEqual(23, self.viewController.testPlanList.testPlanList[0].id)
            XCTAssertEqual(1, self.viewController.testPlanList.testPlanList[0].projectId)
        })
    }
    
    func testDidEndpointLoadWithCycleData() {
        viewController.currentTestLevel = .cycle
        viewController.testPlanList.testPlanList = []
        viewController.selectedPlanIndex = 0
        viewController.testPlanList.testPlanList.append(TestPlanModel())
        var dataList: [[String : AnyObject]] = []
        var cycleData: [String : AnyObject] = [:]
        var fields: [String : AnyObject] = [:]
        cycleData.updateValue(23 as AnyObject, forKey: "id")
        cycleData.updateValue(1 as AnyObject, forKey: "project")
        cycleData.updateValue(36 as AnyObject, forKey: "itemType")
        fields.updateValue("testCycle" as AnyObject, forKey: "name")
        fields.updateValue(planId as AnyObject, forKey: "testPlan")
        cycleData.updateValue(fields as AnyObject, forKey: "fields")
        
        dataList.append(cycleData)
        
        viewController.didLoadEndpoint(data: dataList, totalItems: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            XCTAssertEqual("testCycle", self.viewController.testPlanList.testPlanList[0].name)
            XCTAssertEqual(23, self.viewController.testPlanList.testPlanList[0].id)
            XCTAssertEqual(1, self.viewController.testPlanList.testPlanList[0].projectId)
        })
    }
 }
