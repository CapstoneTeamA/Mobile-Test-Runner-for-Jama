//
//  TestRunModel.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

class TestRunModel {
    var description = "No Runs Found"
    var id = -1
    var name = "No Runs Found"
    var assignedTo = -1
    
    func extractPlan(fromData: [String: AnyObject]) {
        id = fromData["id"] as! Int
        let fields: [String :  AnyObject] = fromData["fields"] as! Dictionary
        name = fields["name"] as! String
        let assignedToWrappedValue = fields["assignedTo"]
        if assignedToWrappedValue != nil {
            assignedTo = assignedToWrappedValue as! Int
        }
        
        description = fields["description"] as! String
    }
}
