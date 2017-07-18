//
//  ProjectListModel.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

class ProjectListModel {
    var projectList : [ProjectModel] = []
    
    func extractProjectList(fromData: [[String : AnyObject]]) {
        for projectsData in fromData {
            let tmpProj = ProjectModel()
            tmpProj.extractProject(fromData: projectsData)
            projectList.append(tmpProj)
            
        }
    }
}
