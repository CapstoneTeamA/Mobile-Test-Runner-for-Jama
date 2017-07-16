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
    
    let projects: ProjectListViewController = ProjectListViewController ()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test(){
        projects.currentUser.username = "demo"
        projects.username = "demo"
        projects.password = "password"
        projects.instance = "capstone-sandbox"
        
        //For personal testing Okay to delete (jason)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            XCTAssertEqual(self.projects.projectList.projectList[0].name, "Achiever UAV Sample Set")
            
        })
        
    }
}
