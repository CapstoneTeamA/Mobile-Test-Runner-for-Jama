//
//  ProjectListModelUnitTests.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import XCTest
@testable import Mobile_Test_Runner_for_Jama
class ProjectListModelUnitTests: XCTestCase {
    var projectList = ProjectListModel()
    var projectsData: [[String: AnyObject]] = []
    var proj1data: [String : AnyObject] = [:]
    var proj2data: [String : AnyObject] = [:]
    var proj1fields: [String : AnyObject] = [:]
    var proj2fields: [String : AnyObject] = [:]
    var proj1name = "proj1"
    var proj2name = "proj2"
    var proj1key = "AAA"
    var proj2key = "BBB"
    var proj1id = 23
    var proj2id = 31
    
    override func setUp() {
        super.setUp()
        //build project 1 data
        proj1fields.updateValue(proj1name as AnyObject, forKey: "name")
        proj1fields.updateValue(proj1key as AnyObject, forKey: "projectKey")
        proj1data.updateValue(proj1fields as AnyObject, forKey: "fields")
        proj1data.updateValue(proj1id as AnyObject, forKey: "id")
        //build project 2 data
        proj2fields.updateValue(proj2name as AnyObject, forKey: "name")
        proj2fields.updateValue(proj2key as AnyObject, forKey: "projectKey")
        proj2data.updateValue(proj2fields as AnyObject, forKey: "fields")
        proj2data.updateValue(proj2id as AnyObject, forKey: "id")
        
        //add both projects data to the array
        projectsData.append(proj1data)
        projectsData.append(proj2data)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExtractProjectListFromData() {
        projectList.extractProjectList(fromData: projectsData)
        
        //Check project 1 is correctly created
        XCTAssertEqual(proj1name, projectList.projectList[0].name)
        XCTAssertEqual(proj1key, projectList.projectList[0].projectKey)
        XCTAssertEqual(proj1id, projectList.projectList[0].id)
        //Check project 2 is correctly created
        XCTAssertEqual(proj2name, projectList.projectList[1].name)
        XCTAssertEqual(proj2key, projectList.projectList[1].projectKey)
        XCTAssertEqual(proj2id, projectList.projectList[1].id)
        
    }
    
    func testExtractEmptyProjectListFromData() {
        projectList.extractProjectList(fromData: [])
        
        XCTAssertTrue(projectList.projectList.isEmpty)
    }
}
