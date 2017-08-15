//
//  ProjectModel.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

class ProjectModel {
    var name = ""
    var projectKey = ""
    var id = -1
    
    func extractProject(fromData: [String : AnyObject]) {
        var fields: [String : AnyObject] = [:]
        guard fromData["fields"] != nil else {
            return
        }
        
       
        fields = fromData["fields"] as! Dictionary
        id = fromData["id"] as! Int
        name = fields["name"] as! String
        
        guard fields["projectKey"] != nil  else{
            return
        }
        projectKey = fields["projectKey"] as! String
    }
}
