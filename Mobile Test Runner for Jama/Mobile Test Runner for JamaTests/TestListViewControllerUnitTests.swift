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
    let testCycleId = 6835
    var viewController : TestListViewController!
    let instance = "test-instance"
    let planFont = UIFont(name: "Helvetica Neue", size: 20.0)
    let cycleFont = UIFont(name: "Helvetica Neue", size: 18.0)
    let runFont = UIFont(name: "Helvetica Neue", size: 17.0)
    let currentUser = UserModel()
    let indexPath = IndexPath(row: 0, section: 0)
    let timestampString = "2017-8-18 05:59:00.0023"
    
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TestList") as! TestListViewController
        _ = viewController.view
        viewController.projectId = projectId
        viewController.instance = instance
        viewController.selectedTestCycleId = testCycleId
        viewController.selectedPlanId = planId
        viewController.currentUser = currentUser
        viewController.currentUser.id = 54459
        
        let testPlan1 = TestPlanModel()
        let testPlan2 = TestPlanModel()
        let testCycle1 = TestCycleModel()
        let testCycle2 = TestCycleModel()
        let testRun1 = TestRunModel()
        let testRun2 = TestRunModel()
        let testRun3 = TestRunModel()
        
        testPlan1.id = 23
        testPlan1.name = "testPlan1"
        testPlan1.projectId = 2
        testPlan1.archived = false
        
        testPlan2.id = 31
        testPlan2.name = "testPlan2"
        testPlan2.projectId = 2
        testPlan2.archived = false
        
        testCycle1.id = 123
        testCycle1.name = "testCycle1"
        
        testCycle2.id = 124
        testCycle2.name = "testCycle2"
        
        testRun1.id = 2323
        testRun1.name = "testRun1"
        testRun1.testStatus = "INPROGRESS"
        
        testRun2.id = 2324
        testRun2.name = "testRun2"
        testRun2.testStatus = "NOT_RUN"
        
        testRun3.id = 2325
        testRun2.name = "testRun3"
        testRun2.testStatus = "FAILED"
        
        
        viewController.selectedPlanIndex = 1
        viewController.testPlanList.testPlanList.append(testPlan1)
        viewController.testPlanList.testPlanList.append(testPlan2)
        viewController.testCycleList.testCycleList.append(testCycle1)
        viewController.testCycleList.testCycleList.append(testCycle2)
        viewController.testRunList.testRunList.append(testRun1)
        viewController.testRunList.testRunList.append(testRun2)
        viewController.testRunList.testRunList.append(testRun3)
        viewController.apiTimestamp = timestampString
        
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
        viewController.selectedPlanId = 45
        let endpointString = viewController.buildTestCycleEndpointString()

        XCTAssertEqual("https://test-instance.jamacloud.com/rest/latest/testplans/45/testcycles", endpointString)
    }
    
    func testBuildTestRunEndpointString() {
        viewController.selectedTestCycleId = 23
        let endpointString = viewController.buildTestRunEndpointString()
        XCTAssertEqual("https://test-instance.jamacloud.com/rest/latest/testruns?testCycle=23", endpointString)
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
        let planBackgroundColor = UIColor.init(red: 0xE6/0xFF, green: 0xE6/0xFF, blue: 0xE6/0xFF, alpha: 1)
        let cycleBackgroundColor = UIColor.init(red: 0xF5/0xFF, green: 0xF5/0xFF, blue: 0xF5/0xFF, alpha: 1)
        let runBackgroundColor = UIColor.white

        viewController.selectedPlanIndex = 1
        viewController.selectedCycleIndex = 1
        viewController.selectedCycleTableViewIndex = 3
        var cell = viewController.buildCell(indexPath: IndexPath(row: 0, section: 0))

        XCTAssertEqual("testPlan1", cell.nameLabel.text)
        XCTAssertEqual(NSTextAlignment.left, cell.nameLabel?.textAlignment)
        XCTAssertEqual(planFont, cell.nameLabel?.font)
        XCTAssertEqual("TestPlanCell", cell.reuseIdentifier)
        XCTAssertEqual(planBackgroundColor, cell.backgroundColor)
        
        cell = viewController.buildCell(indexPath: IndexPath(row: 1, section: 0))
        
        XCTAssertEqual("testPlan2", cell.nameLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.nameLabel?.textAlignment)
        XCTAssertEqual(planFont, cell.nameLabel?.font)
        XCTAssertEqual("TestPlanCell", cell.reuseIdentifier)
        XCTAssertEqual(planBackgroundColor, cell.backgroundColor)

        cell = viewController.buildCell(indexPath: IndexPath(row: 2, section: 0))
        
        XCTAssertEqual("testCycle1", cell.nameLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.nameLabel?.textAlignment)
        XCTAssertEqual(cycleFont, cell.nameLabel?.font)
        XCTAssertEqual("TestCycleCell", cell.reuseIdentifier)
        XCTAssertEqual(cycleBackgroundColor, cell.backgroundColor)
        
        cell = viewController.buildCell(indexPath: IndexPath(row: 3, section: 0))
        
        XCTAssertEqual("testCycle2", cell.nameLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.nameLabel?.textAlignment)
        XCTAssertEqual(cycleFont, cell.nameLabel?.font)
        XCTAssertEqual("TestCycleCell", cell.reuseIdentifier)
        XCTAssertEqual(cycleBackgroundColor, cell.backgroundColor)
        
        cell = viewController.buildCell(indexPath: IndexPath(row: 4, section: 0))
        XCTAssertEqual("1. testRun1", cell.nameLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.nameLabel?.textAlignment)
        XCTAssertEqual(runFont, cell.nameLabel?.font)
        XCTAssertEqual("TestRunCell", cell.reuseIdentifier)
        XCTAssertEqual(runBackgroundColor, cell.backgroundColor)
        
        cell = viewController.buildCell(indexPath: IndexPath(row: 5, section: 0))
        XCTAssertEqual("2. testRun3", cell.nameLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.nameLabel?.textAlignment)
        XCTAssertEqual(runFont, cell.nameLabel?.font)
        XCTAssertEqual("TestRunCell", cell.reuseIdentifier)
        XCTAssertEqual(runBackgroundColor, cell.backgroundColor)
        
        cell = viewController.buildCell(indexPath: IndexPath(row: 6, section: 0))
        XCTAssertEqual("3. No Runs Found", cell.nameLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.nameLabel?.textAlignment)
        XCTAssertEqual(runFont, cell.nameLabel?.font)
        XCTAssertEqual("TestRunCell", cell.reuseIdentifier)
        XCTAssertEqual(runBackgroundColor, cell.backgroundColor)
        
        viewController.selectedPlanIndex = 0
        viewController.selectedCycleIndex = 1
        viewController.selectedCycleTableViewIndex = 2
        
        cell = viewController.buildCell(indexPath: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual("testPlan1", cell.nameLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.nameLabel?.textAlignment)
        XCTAssertEqual(planFont, cell.nameLabel?.font)
        XCTAssertEqual("TestPlanCell", cell.reuseIdentifier)
        XCTAssertEqual(planBackgroundColor, cell.backgroundColor)
        
        cell = viewController.buildCell(indexPath: IndexPath(row: 1, section: 0))
        
        XCTAssertEqual("testCycle1", cell.nameLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.nameLabel?.textAlignment)
        XCTAssertEqual(cycleFont, cell.nameLabel?.font)
        XCTAssertEqual("TestCycleCell", cell.reuseIdentifier)
        XCTAssertEqual(cycleBackgroundColor, cell.backgroundColor)
        
        
        cell = viewController.buildCell(indexPath: IndexPath(row: 2, section: 0))
        
        XCTAssertEqual("testCycle2", cell.nameLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.nameLabel?.textAlignment)
        XCTAssertEqual(cycleFont, cell.nameLabel?.font)
        XCTAssertEqual("TestCycleCell", cell.reuseIdentifier)
        XCTAssertEqual(cycleBackgroundColor, cell.backgroundColor)
        
        cell = viewController.buildCell(indexPath: IndexPath(row: 3, section: 0))
        
        XCTAssertEqual("1. testRun1", cell.nameLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.nameLabel?.textAlignment)
        XCTAssertEqual(runFont, cell.nameLabel?.font)
        XCTAssertEqual("TestRunCell", cell.reuseIdentifier)
        XCTAssertEqual(runBackgroundColor, cell.backgroundColor)
        
        cell = viewController.buildCell(indexPath: IndexPath(row: 4, section: 0))
        XCTAssertEqual("2. testRun3", cell.nameLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.nameLabel?.textAlignment)
        XCTAssertEqual(runFont, cell.nameLabel?.font)
        XCTAssertEqual("TestRunCell", cell.reuseIdentifier)
        XCTAssertEqual(runBackgroundColor, cell.backgroundColor)
        
        cell = viewController.buildCell(indexPath: IndexPath(row: 5, section: 0))
        XCTAssertEqual("3. No Runs Found", cell.nameLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.nameLabel?.textAlignment)
        XCTAssertEqual(runFont, cell.nameLabel?.font)
        XCTAssertEqual("TestRunCell", cell.reuseIdentifier)
        XCTAssertEqual(runBackgroundColor, cell.backgroundColor)
        
        cell = viewController.buildCell(indexPath: IndexPath(row: 6, section: 0))
        XCTAssertEqual("testPlan2", cell.nameLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.nameLabel?.textAlignment)
        XCTAssertEqual(planFont, cell.nameLabel?.font)
        XCTAssertEqual("TestPlanCell", cell.reuseIdentifier)
        XCTAssertEqual(planBackgroundColor, cell.backgroundColor)
        
        viewController.selectedCycleIndex = 0
        viewController.selectedCycleTableViewIndex = 1
        viewController.selectedPlanIndex = 0
        cell = viewController.buildCell(indexPath: IndexPath(row: 3, section: 0))
        
        XCTAssertEqual("2. testRun3", cell.nameLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.nameLabel?.textAlignment)
        XCTAssertEqual(runFont, cell.nameLabel?.font)
        XCTAssertEqual("TestRunCell", cell.reuseIdentifier)
        XCTAssertEqual(runBackgroundColor, cell.backgroundColor)
        
        viewController.selectedCycleIndex = viewController.largeNumber
        viewController.selectedCycleTableViewIndex = viewController.largeNumber
        viewController.selectedPlanIndex = 0
        cell = viewController.buildCell(indexPath: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual("testPlan1", cell.nameLabel?.text)
        XCTAssertEqual(NSTextAlignment.left, cell.nameLabel?.textAlignment)
        XCTAssertEqual(0, cell.indentationLevel)
        XCTAssertEqual(planFont, cell.nameLabel?.font)
        XCTAssertEqual("TestPlanCell", cell.reuseIdentifier)
        XCTAssertEqual(planBackgroundColor, cell.backgroundColor)
        
        
    }
    
    func testDidLoadEndpointEmptyPlanList() {
        viewController.currentTestLevel = .plan
        viewController.testPlanList.testPlanList = []
        viewController.didLoadEndpoint(data: [], totalItems: 0, timestamp: timestampString)
        XCTAssertTrue(viewController.testPlanList.testPlanList.isEmpty)
    }
    
    func testDidLoadEndpointEmptyCycleList() {
        viewController.currentTestLevel = .cycle
        viewController.testCycleList.testCycleList = []
        viewController.didLoadEndpoint(data: [], totalItems: 0, timestamp: timestampString)
        XCTAssertTrue(viewController.testCycleList.testCycleList.isEmpty)
    }
    
    func testDidLoadEndpointEmptyRunList() {
        viewController.currentTestLevel = .run
        viewController.testRunList.testRunList = []
        viewController.didLoadEndpoint(data: [], totalItems: 0, timestamp: timestampString)
        XCTAssertTrue(viewController.testRunList.testRunList.isEmpty)
    }
    
    func testDidLoadEndpointNilList() {
        viewController.currentTestLevel = .plan
        viewController.testPlanList.testPlanList = []
        viewController.didLoadEndpoint(data: nil, totalItems: 0, timestamp: timestampString)
        XCTAssertTrue(viewController.testPlanList.testPlanList.isEmpty)
        
        viewController.currentTestLevel = .cycle
        viewController.testCycleList.testCycleList = []
        viewController.didLoadEndpoint(data: nil, totalItems: 0, timestamp: timestampString)
        XCTAssertTrue(viewController.testCycleList.testCycleList.isEmpty)
        
        viewController.currentTestLevel = .run
        viewController.testRunList.testRunList = []
        viewController.didLoadEndpoint(data: nil, totalItems: 0, timestamp: timestampString)
        XCTAssertTrue(viewController.testRunList.testRunList.isEmpty)
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
        planData.updateValue(false as AnyObject, forKey: "archived")
        fields.updateValue("testPlan" as AnyObject, forKey: "name")
        planData.updateValue(fields as AnyObject, forKey: "fields")
        
        dataList.append(planData)
        
        viewController.didLoadEndpoint(data: dataList, totalItems: 1, timestamp: timestampString)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            XCTAssertEqual("testPlan", self.viewController.testPlanList.testPlanList[0].name)
            XCTAssertEqual(23, self.viewController.testPlanList.testPlanList[0].id)
            XCTAssertEqual(1, self.viewController.testPlanList.testPlanList[0].projectId)
        })
    }
    
    func testDidLoadEndpointWithCycleData() {
        let cycleId = 23
        let projId = 1
        let jamaItemTypeId = 36
        viewController.currentTestLevel = .cycle
        viewController.testPlanList.testPlanList = []
        viewController.selectedPlanIndex = 0
        viewController.testPlanList.testPlanList.append(TestPlanModel())
        var dataList: [[String : AnyObject]] = []
        var cycleData: [String : AnyObject] = [:]
        var fields: [String : AnyObject] = [:]
        cycleData.updateValue(cycleId as AnyObject, forKey: "id")
        cycleData.updateValue(projId as AnyObject, forKey: "project")
        cycleData.updateValue(jamaItemTypeId as AnyObject, forKey: "itemType")
        fields.updateValue("testCycle1" as AnyObject, forKey: "name")
        fields.updateValue(planId as AnyObject, forKey: "testPlan")
        cycleData.updateValue(fields as AnyObject, forKey: "fields")
        
        dataList.append(cycleData)
        
        viewController.didLoadEndpoint(data: dataList, totalItems: 1, timestamp: timestampString)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            XCTAssertEqual("testCycle1", self.viewController.testCycleList.testCycleList[0].name)
            XCTAssertEqual(cycleId, self.viewController.testCycleList.testCycleList[0].id)
        })
    }
    
    func testDidLoadEndpointWithRunData() {
        let runId = 23
        let parentCycleId = 22
        let projId = 1
        let jamaItemTypeId = 37
        viewController.currentTestLevel = .run
        viewController.selectedTestCycleId = parentCycleId
        
        var dataList: [[String : AnyObject]] = []
        var runData: [String : AnyObject] = [:]
        var fields: [String : AnyObject] = [:]
        
        runData.updateValue(runId as AnyObject, forKey: "id")
        runData.updateValue(projId as AnyObject, forKey: "project")
        runData.updateValue(jamaItemTypeId as AnyObject, forKey: "itemType")
        fields.updateValue("testRun1" as AnyObject, forKey: "name")
        fields.updateValue("desc" as AnyObject, forKey: "description")
        fields.updateValue(parentCycleId as AnyObject, forKey: "testCycle")
        fields.updateValue("NOT_RUN" as AnyObject, forKey: "testRunStatus")
        runData.updateValue(fields as AnyObject, forKey: "fields")
        
        dataList.append(runData)
        
        viewController.didLoadEndpoint(data: dataList, totalItems: 1, timestamp: timestampString)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            XCTAssertEqual("testRun1", self.viewController.testRunList.testRunList[0].name)
            XCTAssertEqual(runId, self.viewController.testRunList.testRunList[0].id)
            XCTAssertEqual("desc", self.viewController.testRunList.testRunList[0].description)
        })
    }
    
    func testDidTapTestPlanCellBeforeSelectedCycle() {
        viewController.selectedPlanIndex = 1
        let tableIndexToTap = 0
        let planIndexForTappedCell = 0
        viewController.didTapTestPlanCell(indexPath: IndexPath(row: tableIndexToTap, section: 0))
        
        XCTAssertEqual(viewController.largeNumber, viewController.selectedCycleTableViewIndex)
        XCTAssertEqual(viewController.largeNumber, viewController.selectedCycleIndex)
        XCTAssertEqual(planIndexForTappedCell, viewController.selectedPlanIndex)
        XCTAssertTrue(viewController.testCycleList.testCycleList.isEmpty)
        XCTAssertTrue(viewController.testRunList.testRunList.isEmpty)
        XCTAssertEqual(viewController.testPlanList.testPlanList[planIndexForTappedCell].id, viewController.selectedPlanId)
    }
    
    func testDidTapTestPlanCellAfterSelectedPlan() {
        let tableIndexToTap = 6
        let planIndexForTappedCell = 1
        
        viewController.selectedPlanIndex = 0
        viewController.selectedCycleIndex = 0
        viewController.selectedCycleTableViewIndex = 1
        viewController.didTapTestPlanCell(indexPath: IndexPath(row: tableIndexToTap, section: 0))
        
        XCTAssertEqual(viewController.largeNumber, viewController.selectedCycleTableViewIndex)
        XCTAssertEqual(viewController.largeNumber, viewController.selectedCycleIndex)
        XCTAssertEqual(planIndexForTappedCell, viewController.selectedPlanIndex)
        XCTAssertTrue(viewController.testCycleList.testCycleList.isEmpty)
        XCTAssertTrue(viewController.testRunList.testRunList.isEmpty)
        XCTAssertEqual(viewController.testPlanList.testPlanList[planIndexForTappedCell].id, viewController.selectedPlanId)
        
    }
    
    func testDidTapTestCycleCellBeforeSelectedCycle() {
        let tableIndexToTap = 2
        viewController.selectedPlanIndex = 1
        viewController.selectedCycleIndex = 1
        viewController.selectedCycleTableViewIndex = 3
        let expectedSelectedCycleIndex = 0
        viewController.didTapTestCycleCell(indexPath: IndexPath(row: tableIndexToTap, section: 0))
        
        XCTAssertEqual(expectedSelectedCycleIndex, viewController.selectedCycleIndex)
        XCTAssertEqual(tableIndexToTap, viewController.selectedCycleTableViewIndex)
        XCTAssertTrue(viewController.testRunList.testRunList.isEmpty)
        XCTAssertEqual(viewController.testCycleList.testCycleList[expectedSelectedCycleIndex].id, viewController.selectedTestCycleId)
    }
    
    func testDidTapTestCycleCellAfterSelectedCycle() {
        let tableIndexToTap = 6
        viewController.selectedPlanIndex = 1
        viewController.selectedCycleIndex = 0
        viewController.selectedCycleTableViewIndex = 2
        let expectedSelectedCycleIndex = 1
        let expectedSelectedCycleTableViewIndex = tableIndexToTap - viewController.testRunList.testRunList.count
        viewController.didTapTestCycleCell(indexPath: IndexPath(row: tableIndexToTap, section: 0))
        
        XCTAssertEqual(expectedSelectedCycleIndex, viewController.selectedCycleIndex)
        XCTAssertEqual(expectedSelectedCycleTableViewIndex, viewController.selectedCycleTableViewIndex)
        XCTAssertTrue(viewController.testRunList.testRunList.isEmpty)
        XCTAssertEqual(viewController.testCycleList.testCycleList[expectedSelectedCycleIndex].id, viewController.selectedTestCycleId)
    }
    
//    func testUnselectTestPlanForAlreadySelectedPlan() {
//        viewController.selectedPlanIndex = 0
//        viewController.selectedCycleIndex = 0
//        viewController.selectedCycleTableViewIndex = 1
//        
//        XCTAssertFalse(viewController.testCycleList.testCycleList.isEmpty)
//        XCTAssertFalse(viewController.testRunList.testRunList.isEmpty)
//        
//        let result = viewController.unselectTestPlan(indexPath: IndexPath(row: 0, section: 0))
//        
//        XCTAssertTrue(result)
//        XCTAssertEqual(viewController.largeNumber, viewController.selectedPlanIndex)
//        XCTAssertEqual(viewController.largeNumber, viewController.selectedCycleIndex)
//        XCTAssertEqual(viewController.largeNumber, viewController.selectedCycleTableViewIndex)
//        XCTAssertTrue(viewController.testCycleList.testCycleList.isEmpty)
//        XCTAssertTrue(viewController.testRunList.testRunList.isEmpty)
//    }
    
    func testUnselectTestPlanForPlanNotalreadySelected() {
        viewController.selectedPlanIndex = 1
        viewController.selectedCycleIndex = 0
        viewController.selectedCycleTableViewIndex = 2
        
        let result = viewController.unselectTestPlan(indexPath: IndexPath(row: 0, section: 0))
        
        XCTAssertFalse(result)
    }
    
//    func testUnselectTestCycleForAlreadySelectedPlan() {
//        viewController.selectedPlanIndex = 0
//        viewController.selectedCycleIndex = 0
//        viewController.selectedCycleTableViewIndex = 1
//        
//        XCTAssertFalse(viewController.testRunList.testRunList.isEmpty)
//        
//        let result = viewController.unselectTestCycle(indexPath: IndexPath(row: 1, section: 0))
//        
//        XCTAssertTrue(result)
//        XCTAssertEqual(viewController.largeNumber, viewController.selectedCycleTableViewIndex)
//        XCTAssertEqual(viewController.largeNumber, viewController.selectedCycleIndex)
//        XCTAssertTrue(viewController.testRunList.testRunList.isEmpty)
//    }
    
    func testUnselectTestCycleForPlanNotalreadySelected() {
        viewController.selectedPlanIndex = 0
        viewController.selectedCycleIndex = 0
        viewController.selectedCycleTableViewIndex = 1
        
        XCTAssertFalse(viewController.testRunList.testRunList.isEmpty)
        
        let result = viewController.unselectTestCycle(indexPath: IndexPath(row: 2, section: 0))
        
        XCTAssertFalse(result)
    }
    func testDefaultCycleVals() {
        let testCycle = TestCycleModel()
        XCTAssertEqual(testCycle.name, "No Cycles Found")
    }
    func testDefaultRunVals() {
        let testRun = TestRunModel()
        XCTAssertEqual(testRun.name, "No Runs Found")
    }
    
    func testDisplayTestRunAlertInitiallyFalse() {
        viewController.loadView()
        
        XCTAssertFalse(viewController.displayTestRunAlert)
    }
    
    func testDisplayTestRunAlertTrueOnApiUpdate() {
        //displayTestRunAlert initially false
        viewController.loadView()
        XCTAssertFalse(viewController.displayTestRunAlert)
        
        //after api update displayTestRunAlert set to true
        viewController.didUpdateTestRun()
        XCTAssertTrue(viewController.displayTestRunAlert)
        
        //After the viewDidAppear is called displayTestRunAlert is reset to false
        viewController.viewDidAppear(false)
        XCTAssertFalse(viewController.displayTestRunAlert)
    }
 }
