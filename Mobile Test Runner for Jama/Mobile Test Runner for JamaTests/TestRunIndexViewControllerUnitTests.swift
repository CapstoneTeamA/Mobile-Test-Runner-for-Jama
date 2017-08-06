//
//  TestRunIndexViewControllerUnitTests.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 8/5/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import XCTest
@testable import Mobile_Test_Runner_for_Jama
class TestRunIndexViewControllerUnitTests: XCTestCase {
    var viewController: TestRunIndexViewController!
    var run: TestRunModel!
    override func setUp() {
        super.setUp()
        run = TestRunModel()
        viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TestRunIndex") as! TestRunIndexViewController
        _ = viewController.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNoStepsViewNotHidden() {
        XCTAssertFalse(viewController.noStepsView.isHidden)
    }
    
    func testNoStepsViewIsHiddenIfStepsExist() {
        let run = TestRunModel()
        let step = TestStepModel()
        run.testStepList.append(step)
        viewController.testRun = run
        viewController.viewWillAppear(false)

        XCTAssertTrue(viewController.noStepsView.isHidden)
    }
    
    func testStepsShowUpInTable() {
        let step1 = TestStepModel()
        let step2 = TestStepModel()
        let step3 = TestStepModel()
        step1.action = "test step action"
        step1.status = "PASSED"
        step2.action = "test step action 2"
        step2.status = "FAILED"
        step3.action = "test step action 3"
        step3.status = "NOT_RUN"
        
        run.testStepList.append(step1)
        run.testStepList.append(step2)
        run.testStepList.append(step3)
        
        viewController.testRun = run
        viewController.testStepTable.reloadData()
        
        var cell = viewController.testStepTable.cellForRow(at: IndexPath(item: 0, section: 0)) as! TestStepTableViewCell
        XCTAssertEqual("test step action", cell.nameLabel.text)
        XCTAssertEqual("check_icon_green.png", cell.iconFileName)
        XCTAssertEqual("1", cell.numberLabel.text)
        cell = viewController.testStepTable.cellForRow(at: IndexPath(item: 1, section: 0)) as! TestStepTableViewCell
        XCTAssertEqual("test step action 2", cell.nameLabel.text)
        XCTAssertEqual("X_icon_red.png", cell.iconFileName)
        XCTAssertEqual("2", cell.numberLabel.text)
        cell = viewController.testStepTable.cellForRow(at: IndexPath(item: 2, section: 0)) as! TestStepTableViewCell
        XCTAssertEqual("test step action 3", cell.nameLabel.text)
        XCTAssertEqual("empty_icon_grey.png", cell.iconFileName)
        XCTAssertEqual("3", cell.numberLabel.text)
    }
    
    func testCellIconUpdatesWithStatusOnReload() {
        let step1 = TestStepModel()
        let step2 = TestStepModel()
        let step3 = TestStepModel()
        step1.action = "test step action"
        step1.status = "PASSED"
        step2.action = "test step action 2"
        step2.status = "FAILED"
        step3.action = "test step action 3"
        step3.status = "NOT_RUN"
        
        run.testStepList.append(step1)
        run.testStepList.append(step2)
        run.testStepList.append(step3)
        
        run.testStepList[0].status = "NOT_RUN"
        run.testStepList[1].status = "PASSED"
        run.testStepList[2].status = "FAILED"
        viewController.testRun = run
        viewController.testStepTable.reloadData()
        
        var cell = viewController.testStepTable.cellForRow(at: IndexPath(item: 0, section: 0)) as! TestStepTableViewCell
        
        XCTAssertEqual("empty_icon_grey.png", cell.iconFileName)
        
        cell = viewController.testStepTable.cellForRow(at: IndexPath(item: 1, section: 0)) as! TestStepTableViewCell
        XCTAssertEqual("check_icon_green.png", cell.iconFileName)
        
        cell = viewController.testStepTable.cellForRow(at: IndexPath(item: 2, section: 0)) as! TestStepTableViewCell
        XCTAssertEqual("X_icon_red.png", cell.iconFileName)
    }
    
    func testPreserveCurrentRunStatus() {
        let step1 = TestStepModel()
        let step2 = TestStepModel()
        let step3 = TestStepModel()
        step1.action = "test step action"
        step1.status = "PASSED"
        step1.result = "step 1 results"
        step2.action = "test step action 2"
        step2.status = "FAILED"
        step2.result = "step 2 results"
        step3.action = "test step action 3"
        step3.status = "NOT_RUN"
        step3.result = "step 3 results"
        
        run.testStepList.append(step1)
        run.testStepList.append(step2)
        run.testStepList.append(step3)
        viewController.testRun = run
        viewController.preserveCurrentRunStatus()
        
        run.testStepList[0].status = "NOT_RUN"
        run.testStepList[1].status = "PASSED"
        run.testStepList[2].status = "FAILED"
        
        run.testStepList[0].result = "new result 1"
        run.testStepList[1].result = "new result 2"
        run.testStepList[2].result = "new result 3"
        
        XCTAssertEqual("PASSED", viewController.initialStepsStatusList[0])
        XCTAssertEqual("FAILED", viewController.initialStepsStatusList[1])
        XCTAssertEqual("NOT_RUN", viewController.initialStepsStatusList[2])

        XCTAssertEqual("step 1 results", viewController.initialStepsResultsList[0])
        XCTAssertEqual("step 2 results", viewController.initialStepsResultsList[1])
        XCTAssertEqual("step 3 results", viewController.initialStepsResultsList[2])
    }
    
}