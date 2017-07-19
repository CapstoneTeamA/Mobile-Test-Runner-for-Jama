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
    
    
    let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProjectListViewController") as! ProjectListViewController
    
    override func setUp() {
        super.setUp()
        
        _ = viewController.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSucellfulGetProjects(){
        viewController.currentUser.username = "demo"
        viewController.username = "demo"
        viewController.password = "password"
        viewController.instance = "capstone-sandbox"
        
        //For fixing the timing issue testing has
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            XCTAssertEqual(self.viewController.projectList.projectList[0].name, "Achiever UAV Sample Set")
            
        })
    }
    
    func testProjectListIsNil(){
        viewController.didLoadEndpoint(data: nil)
        XCTAssertEqual(viewController.serverErrorMessage.isHidden, false)
        
    }
    
    
}
