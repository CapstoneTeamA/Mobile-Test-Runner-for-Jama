//
//  ProjectListViewControllerUnitTests.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import XCTest
@testable import Mobile_Test_Runner_for_Jama
class ProjectListViewControllerUnitTests: XCTestCase {
    var viewController: ProjectListViewController!
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProjectListViewController") as! ProjectListViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBuildLayout() {
        let layout = viewController.buildCollectionLayout()
        let screenWidth = UIScreen.main.bounds.width
        
        XCTAssertEqual(6, layout.minimumLineSpacing)
        XCTAssertEqual(1000, layout.minimumInteritemSpacing)
        XCTAssertEqual(screenWidth - 20, layout.itemSize.width)
        XCTAssertEqual(60, layout.itemSize.height)
    }
    
    func testPrepCell() {
        let cell = ProjectCollectionViewCell()
        
        viewController.prepCell(forCell: cell, withLabelText: "test")
        
        XCTAssertEqual(5.0, cell.layer.cornerRadius)
        XCTAssertEqual(UIColor.lightGray.cgColor, cell.layer.shadowColor)
        XCTAssertEqual(0, cell.layer.shadowOffset.width)
        XCTAssertEqual(2.0, cell.layer.shadowOffset.height)
        XCTAssertEqual(2.0, cell.layer.shadowRadius)
        XCTAssertEqual(1.0, cell.layer.shadowOpacity)
        XCTAssertFalse(cell.layer.masksToBounds)
        
        let shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.layer.cornerRadius).cgPath
        XCTAssertEqual(shadowPath, cell.layer.shadowPath)
    }
}
