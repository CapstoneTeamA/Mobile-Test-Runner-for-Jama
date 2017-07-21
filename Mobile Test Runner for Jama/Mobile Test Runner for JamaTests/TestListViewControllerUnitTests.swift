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
    var viewController : TestListViewController!
    let instance = "test-instance"
    
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TestList") as! TestListViewController
        viewController.projectId = projectId
        viewController.instance = instance
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
}
