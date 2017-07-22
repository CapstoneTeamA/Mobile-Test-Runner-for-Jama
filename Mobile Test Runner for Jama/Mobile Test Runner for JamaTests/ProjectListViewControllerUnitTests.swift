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
        _ = viewController.view
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
        
        viewController.prepCell(forCell: cell)
        
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
    
    func testCompareProjectNames() {
        let proj1 = ProjectModel()
        let proj2 = ProjectModel()
        proj1.name = "zzz"
        proj2.name = "aaa"
        
        //Ensure the compare function returns the expected values for alphabetical order
        XCTAssertTrue(viewController.compareProjectNames(lhs: proj2, rhs: proj1))
        XCTAssertFalse(viewController.compareProjectNames(lhs: proj1, rhs: proj2))
        XCTAssertFalse(viewController.compareProjectNames(lhs: proj1, rhs: proj1))
        
        //Ensure case insensitivity
        proj2.name = "AAA"
        XCTAssertTrue(viewController.compareProjectNames(lhs: proj2, rhs: proj1))
        XCTAssertFalse(viewController.compareProjectNames(lhs: proj1, rhs: proj2))
        XCTAssertFalse(viewController.compareProjectNames(lhs: proj2, rhs: proj2))
        
        //Make sure numbers come before letters in alpha sort comparator
        proj2.name = "111"
        XCTAssertTrue(viewController.compareProjectNames(lhs: proj2, rhs: proj1))
        XCTAssertFalse(viewController.compareProjectNames(lhs: proj1, rhs: proj2))
        XCTAssertFalse(viewController.compareProjectNames(lhs: proj2, rhs: proj2))
        
        //Make sure that number are sorted as expected in alpha sort comparator
        proj1.name = "222"
        XCTAssertTrue(viewController.compareProjectNames(lhs: proj2, rhs: proj1))
        XCTAssertFalse(viewController.compareProjectNames(lhs: proj1, rhs: proj2))
        XCTAssertFalse(viewController.compareProjectNames(lhs: proj2, rhs: proj2))
    }
    
    func testBuildCellt() {
        let indexPath = IndexPath(item: 0, section: 0)
        let project = ProjectModel()
        project.name = "testProject"
        viewController.projectList.projectList.append(project)
        viewController.collectionView.reloadData()
        
        let result = viewController.buildCell(indexPath: indexPath)
        XCTAssertEqual("testProject", result.projectCellLabel.text)
    }
    
    func testCollectionViewCells() {
        let indexPath = IndexPath(item: 0, section: 0)
        let project = ProjectModel()
        project.name = "testProject"
        viewController.projectList.projectList.append(project)
        viewController.collectionView.reloadData()
        let cell = viewController.collectionView(viewController.collectionView, cellForItemAt: indexPath) as! ProjectCollectionViewCell
        XCTAssertEqual("testProject", cell.projectCellLabel.text)
    }
    
    func testCollectionViewCellCount() {
        let project = ProjectModel()
        project.name = "testProject"
        viewController.projectList.projectList.append(project)
        viewController.collectionView.reloadData()
        XCTAssertEqual(1, viewController.collectionView.numberOfItems(inSection: 0))
        
        let proj2 = ProjectModel()
        proj2.name = "proj2"
        viewController.projectList.projectList.append(proj2)
        viewController.collectionView.reloadData()
        XCTAssertEqual(2, viewController.collectionView(viewController.collectionView, numberOfItemsInSection: 0))
    }
    
    func testSuccessfulGetProjects(){
        viewController.currentUser.username = "demo"
        viewController.username = "demo"
        viewController.password = "password"
        viewController.instance = "capstone-sandbox"
        
        //For fixing the timing issue testing has
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            XCTAssertEqual(self.viewController.projectList.projectList[0].name, "Achiever UAV Sample Set")
            
        })
    }
}
