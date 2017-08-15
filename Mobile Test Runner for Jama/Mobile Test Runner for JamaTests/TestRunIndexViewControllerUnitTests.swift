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
        run.result = "This is the initial result"
        viewController.testRun = run
        viewController.preserveCurrentRunStatus()
        
        viewController.testRun.testStepList[0].status = "NOT_RUN"
        viewController.testRun.testStepList[1].status = "PASSED"
        viewController.testRun.testStepList[2].status = "FAILED"
        
        viewController.testRun.testStepList[0].result = "new result 1"
        viewController.testRun.testStepList[1].result = "new result 2"
        viewController.testRun.testStepList[2].result = "new result 3"
        
        viewController.testRun.result = "This is the new result"
        
        XCTAssertEqual("PASSED", viewController.initialStepsStatusList[0])
        XCTAssertEqual("FAILED", viewController.initialStepsStatusList[1])
        XCTAssertEqual("NOT_RUN", viewController.initialStepsStatusList[2])

        XCTAssertEqual("step 1 results", viewController.initialStepsResultsList[0])
        XCTAssertEqual("step 2 results", viewController.initialStepsResultsList[1])
        XCTAssertEqual("step 3 results", viewController.initialStepsResultsList[2])
        
        XCTAssertEqual("This is the initial result", viewController.initialRunResultField)
    }
    
    func testDidSetStatus() {
        let step = TestStepModel()

        step.action = "test step action"
        step.status = "NOT_RUN"
        step.result = "step 1 results"
        
        let run = TestRunModel()
        run.testStepList.append(step)
        
        viewController.testRun = run
        viewController.currentlySelectedStepIndex = 0
        //Ensure run initially set to not run
        XCTAssertEqual("NOT_RUN", viewController.testRun.testStepList[0].status)
        
        viewController.didSetStatus(status: .fail)
        XCTAssertEqual("FAILED", viewController.testRun.testStepList[0].status)
        
        viewController.didSetStatus(status: .pass)
        XCTAssertEqual("PASSED", viewController.testRun.testStepList[0].status)
        
        viewController.didSetStatus(status: .not_run)
        XCTAssertEqual("NOT_RUN", viewController.testRun.testStepList[0].status)
    }
    
    func testDidSetResult() {
        let step = TestStepModel()
        
        step.action = "test step action"
        step.status = "NOT_RUN"
        step.result = "initial result"
        
        let run = TestRunModel()
        run.testStepList.append(step)
        
        viewController.testRun = run
        viewController.currentlySelectedStepIndex = 0
        XCTAssertEqual("initial result", viewController.testRun.testStepList[0].result)
        
        viewController.didSetResult(result: "new result")
        XCTAssertEqual("new result", viewController.testRun.testStepList[0].result)
    }
    
    func testSetupBlockedStatus() {
        let step1 = TestStepModel()
        let step2 = TestStepModel()
        let step3 = TestStepModel()

        step1.status = "NOT_RUN"
        step2.status = "NOT_RUN"
        step3.status = "NOT_RUN"
        
        run.testStepList.append(step1)
        run.testStepList.append(step2)
        run.testStepList.append(step3)
        
        viewController.testRun = run
        
        viewController.setupBlockedStatus()
        
        XCTAssertEqual("BLOCKED", viewController.testRun.testStepList[0].status)
        XCTAssertEqual("BLOCKED", viewController.testRun.testStepList[1].status)
        XCTAssertEqual("BLOCKED", viewController.testRun.testStepList[2].status)
        
        step1.status = "NOT_RUN"
        step2.status = "PASSED"
        step3.status = "NOT_RUN"
        
        run.testStepList = []
        run.testStepList.append(step1)
        run.testStepList.append(step2)
        run.testStepList.append(step3)
        
        viewController.testRun = run
        
        viewController.setupBlockedStatus()
        
        //Ensure that if there are steps with statuses then only the steps after the last step with a status
        //  is changed to BLOCKED
        XCTAssertEqual("NOT_RUN", viewController.testRun.testStepList[0].status)
        XCTAssertEqual("PASSED", viewController.testRun.testStepList[1].status)
        XCTAssertEqual("BLOCKED", viewController.testRun.testStepList[2].status)
        
        step1.status = "FAILED"
        step2.status = "NOT_RUN"
        step3.status = "NOT_RUN"
        
        run.testStepList = []
        run.testStepList.append(step1)
        run.testStepList.append(step2)
        run.testStepList.append(step3)
        
        viewController.testRun = run
        
        viewController.setupBlockedStatus()
        
        //Ensure that all steps after the last step with a status are changed to BLOCKED
        XCTAssertEqual("FAILED", viewController.testRun.testStepList[0].status)
        XCTAssertEqual("BLOCKED", viewController.testRun.testStepList[1].status)
        XCTAssertEqual("BLOCKED", viewController.testRun.testStepList[2].status)
        
        step1.status = "NOT_RUN"
        step2.status = "PASSED"
        step3.status = "FAILED"
        
        run.testStepList = []
        run.testStepList.append(step1)
        run.testStepList.append(step2)
        run.testStepList.append(step3)
        
        viewController.testRun = run
        
        viewController.setupBlockedStatus()
        
        //Ensure that if the last step has a status other than NOT_RUN then none of the statuses are changed
        XCTAssertEqual("NOT_RUN", viewController.testRun.testStepList[0].status)
        XCTAssertEqual("PASSED", viewController.testRun.testStepList[1].status)
        XCTAssertEqual("FAILED", viewController.testRun.testStepList[2].status)
    }

    func testTogglePassButton() {
        let run = TestRunModel()
        run.testStatus = "NOT_RUN"
        viewController.testRun = run
        XCTAssertEqual(viewController.testRunStatusInProgressStr , viewController.noStepRunStatusLabel.text)
        XCTAssertEqual(viewController.notSelectedFailButtonImage, viewController.noStepFailButton.currentImage)
        XCTAssertEqual(viewController.notSelectedPassButtonImage, viewController.noStepPassButton.currentImage)
        
        //Toggle pass button when neither button is selected
        viewController.togglePassButton()
        XCTAssertEqual(viewController.testRunStatusPassStr, viewController.noStepRunStatusLabel.text)
        XCTAssertEqual(viewController.selectedPassButtonImage, viewController.noStepPassButton.currentImage)
        XCTAssertEqual("PASSED", viewController.testRun.testStatus)
        XCTAssertEqual(viewController.notSelectedFailButtonImage, viewController.noStepFailButton.currentImage)
        
        //Toggle pass button when pass button is selected
        viewController.togglePassButton()
        XCTAssertEqual(viewController.testRunStatusInProgressStr, viewController.noStepRunStatusLabel.text)
        XCTAssertEqual(viewController.notSelectedPassButtonImage, viewController.noStepPassButton.currentImage)
        XCTAssertEqual("INPROGRESS", viewController.testRun.testStatus)
        XCTAssertEqual(viewController.notSelectedFailButtonImage, viewController.noStepFailButton.currentImage)
        
        //Set up view controller to state where fail button is selected
        viewController.noStepFailButton.setImage(viewController.selectedFailButtonImage, for: .normal)
        viewController.noStepRunStatusLabel.text = viewController.testRunStatusFailStr
        viewController.noStepPassButton.setImage(viewController.notSelectedPassButtonImage, for: .normal)
        viewController.testRun.testStatus = "FAILED"
        
        //Toggle pass button when fail button is selected
        viewController.togglePassButton()
        XCTAssertEqual(viewController.testRunStatusPassStr, viewController.noStepRunStatusLabel.text)
        XCTAssertEqual(viewController.selectedPassButtonImage, viewController.noStepPassButton.currentImage)
        XCTAssertEqual("PASSED", viewController.testRun.testStatus)
        XCTAssertEqual(viewController.notSelectedFailButtonImage, viewController.noStepFailButton.currentImage)
    }
    
    func testToggleFailButton() {
        let run = TestRunModel()
        run.testStatus = "NOT_RUN"
        viewController.testRun = run
        XCTAssertEqual(viewController.testRunStatusInProgressStr, viewController.noStepRunStatusLabel.text)
        XCTAssertEqual(viewController.notSelectedFailButtonImage, viewController.noStepFailButton.currentImage)
        XCTAssertEqual(viewController.notSelectedPassButtonImage, viewController.noStepPassButton.currentImage)
        
        //Toggle fail button when neither button is selected
        viewController.toggleFailButton()
        XCTAssertEqual(viewController.testRunStatusFailStr, viewController.noStepRunStatusLabel.text)
        XCTAssertEqual(viewController.selectedFailButtonImage, viewController.noStepFailButton.currentImage)
        XCTAssertEqual("FAILED", viewController.testRun.testStatus)
        XCTAssertEqual(viewController.notSelectedPassButtonImage, viewController.noStepPassButton.currentImage)
        
        //Toggle fail button when fail button is selected
        viewController.toggleFailButton()
        XCTAssertEqual(viewController.testRunStatusInProgressStr, viewController.noStepRunStatusLabel.text)
        XCTAssertEqual(viewController.notSelectedFailButtonImage, viewController.noStepFailButton.currentImage)
        XCTAssertEqual("INPROGRESS", viewController.testRun.testStatus)
        XCTAssertEqual(viewController.notSelectedPassButtonImage, viewController.noStepPassButton.currentImage)
        
        //Set up view controller to state where pass button is selected
        viewController.noStepPassButton.setImage(viewController.selectedPassButtonImage, for: .normal)
        viewController.noStepRunStatusLabel.text = viewController.testRunStatusPassStr
        viewController.noStepFailButton.setImage(viewController.notSelectedFailButtonImage, for: .normal)
        viewController.testRun.testStatus = "PASSED"
        
        //Toggle fail button when pass button is selected
        viewController.toggleFailButton()
        XCTAssertEqual(viewController.testRunStatusFailStr, viewController.noStepRunStatusLabel.text)
        XCTAssertEqual(viewController.selectedFailButtonImage, viewController.noStepFailButton.currentImage)
        XCTAssertEqual("FAILED", viewController.testRun.testStatus)
        XCTAssertEqual(viewController.notSelectedPassButtonImage, viewController.noStepPassButton.currentImage)
    }
}
