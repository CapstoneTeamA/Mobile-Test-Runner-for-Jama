//
//  ProjectModelUnitTests.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import XCTest
@testable import Mobile_Test_Runner_for_Jama
class ProjectModelUnitTests: XCTestCase {
    var project = ProjectModel()
    var projectData: [String : AnyObject] = [:]
    var projectFields: [String : AnyObject] = [:]
    var projectName = "testProject"
    var projectKey = "ABC"
    var id = 23
    
    override func setUp() {
        super.setUp()
        projectFields.updateValue(projectName as AnyObject, forKey: "name")
        projectFields.updateValue(projectKey as AnyObject, forKey: "projectKey")
        projectData.updateValue(id as AnyObject, forKey: "id")
        projectData.updateValue(projectFields as AnyObject, forKey: "fields")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExtractProjectFromData() {
        project.extractProject(fromData: projectData)
        
        XCTAssertEqual(projectName, project.name)
        XCTAssertEqual(projectKey, project.projectKey)
        XCTAssertEqual(id, project.id)
    }
    
    func testExtractProjectFromEmptyData() {
        project.extractProject(fromData: [:])
        
        XCTAssertTrue(project.name.isEmpty)
        XCTAssertTrue(project.projectKey.isEmpty)
        XCTAssertEqual(-1, project.id)
    }
    
}
