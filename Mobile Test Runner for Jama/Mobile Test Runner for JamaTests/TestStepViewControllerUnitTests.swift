//
//  TestStepViewControllerUnitTests.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import XCTest
@testable import Mobile_Test_Runner_for_Jama
class TestStepViewControllerUnitTests: XCTestCase {
    var viewController: TestStepViewController!
    let action = "Test step action"
    let expResult = "Test step xpected Result"
    let notes = "Test step notes"
    let currentIndex = 0
    let indexLength = 3
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Test Step") as! TestStepViewController
        viewController.action = action
        viewController.expResult = expResult
        viewController.notes = notes
        viewController.currentIndex = currentIndex
        viewController.indexLength = indexLength
        _ = viewController.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTextViewsAndTitleInitializedCorrectly() {
        XCTAssertEqual(action, viewController.actionTextView.text)
        XCTAssertEqual(expResult, viewController.expectedResultsTextView.text)
        XCTAssertEqual(notes, viewController.notesTextView.text)
        XCTAssertEqual("Step 1/3", viewController.title)
    }
    
    func testSetPlaceholderText() {
        viewController.stepResult = ""
        
        viewController.setPlaceholderText()
        
        XCTAssertEqual(viewController.placeholderText, viewController.inputResultsTextBox.text)
        XCTAssertEqual(UIColor(red: 0.5882, green: 0.5882, blue: 0.5882, alpha: 1.0), viewController.inputResultsTextBox.textColor)

        viewController.stepResult = "New test result"
        
        viewController.setPlaceholderText()
        
        XCTAssertEqual("New test result", viewController.inputResultsTextBox.text)
    }
    
    func testExpandTextViews() {
        let heightRatio = viewController.textViewHeightRatio
        let totalSpaceBetweenButtons = viewController.totalSpaceBetweenButtons
        let titleAndDividerHeight = viewController.titleAndDividerHeight
        let expectedTextViewHeight = (viewController.actionTextView.superview?.frame.height)! * heightRatio - titleAndDividerHeight - totalSpaceBetweenButtons
        viewController.actionTextViewHeightContraint.constant = 0
        
        //Test expanding and then collapsing the action section
        viewController.expandActionTextView()
        XCTAssertEqual(expectedTextViewHeight, viewController.actionTextViewHeightContraint.constant)
        viewController.expandActionTextView()
        XCTAssertEqual(0, viewController.actionTextViewHeightContraint.constant)
        
        //Test expanding and then collapsing the expected results section
        viewController.expandExpectedResultsTextView()
        XCTAssertEqual(expectedTextViewHeight, viewController.expectedResultsTextViewHeightConstraint.constant)
        viewController.expandExpectedResultsTextView()
        XCTAssertEqual(0, viewController.expectedResultsTextViewHeightConstraint.constant)
        
        //Test expanding and then collapsing the notes section
        viewController.expandNotesTextView()
        XCTAssertEqual(expectedTextViewHeight, viewController.notesTextViewHeightConstraint.constant)
        viewController.expandNotesTextView()
        XCTAssertEqual(0, viewController.notesTextViewHeightConstraint.constant)
    }
    
    func testAlignHeaderButtonsContents() {
        let expectedImageInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        let expectedTitleInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        viewController.alignHeaderButtonContents()
        
        XCTAssertEqual(expectedImageInsets, viewController.actionButton.imageEdgeInsets)
        XCTAssertEqual(expectedTitleInsets, viewController.actionButton.titleEdgeInsets)
        XCTAssertEqual(expectedImageInsets, viewController.expectedResultButton.imageEdgeInsets)
        XCTAssertEqual(expectedTitleInsets, viewController.expectedResultButton.titleEdgeInsets)
        XCTAssertEqual(expectedImageInsets, viewController.notesButton.imageEdgeInsets)
        XCTAssertEqual(expectedTitleInsets, viewController.notesButton.titleEdgeInsets)
    }
}
