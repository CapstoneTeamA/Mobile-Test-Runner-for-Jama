//
//  TestPlanModel.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

class TestPlanModel {
    var name = ""
    var testPlanKey = ""
    var id = -1
    
    func extractTestPlan(fromData: [String : AnyObject]) {
        var fields: [String : AnyObject] = [:]
        guard fromData["fields"] != nil else {
            return
        }
        
        
        fields = fromData["fields"] as! Dictionary
        id = fromData["id"] as! Int
        name = fields["name"] as! String
        
        //Appearently projectKey is not a required field on all projects.
        // Assuming this is true for testPlanKeys as well.
        guard fields["TestPlanKey"] != nil  else{
            return
        }
        testPlanKey = fields["testPlanKey"] as! String
    }
}
