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
    let testCycleId = 6835
    var viewController : TestListViewController!
    let instance = "test-instance"
    
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TestList") as! TestListViewController
        viewController.projectId = projectId
        viewController.instance = instance
        viewController.testCycleId = testCycleId
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBuildEndpointString() {
        let endpointString = viewController.buildTestPlanEndpointString()
        
        XCTAssertEqual("https://test-instance.jamacloud.com/rest/latest/testplans?project=23314", endpointString)
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
        let testPlan = TestPlanModel()
        testPlan.name = "testPlanName"
        let font = UIFont(name: "Helvetica Neue", size: 20.0)
        viewController.testPlanList.testPlanList.append(testPlan)
        let cell = viewController.buildCell(indexPath: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(testPlan.name, cell.textLabel?.text)
        XCTAssertEqual(NSTextAlignment.center, cell.textLabel?.textAlignment)
        XCTAssertEqual(font, cell.textLabel?.font)
    }
    
    
 }
