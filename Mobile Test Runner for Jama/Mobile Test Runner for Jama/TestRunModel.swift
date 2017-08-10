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
    var result = ""
    var testStepList: [TestStepModel] = []
    var testStatus = ""
    
    func extractRun(fromData: [String: AnyObject]) {
        id = fromData["id"] as! Int
        let fields: [String :  AnyObject] = fromData["fields"] as! Dictionary
        name = fields["name"] as! String
        description = fields["description"] as! String
        testStatus = fields["testRunStatus"] as! String
        let assignedToWrappedValue = fields["assignedTo"]
        if assignedToWrappedValue != nil {
            assignedTo = assignedToWrappedValue as! Int
        }
        
        if fields["actualResults"] != nil {
            result = fields["actualResults"] as! String
        }
        
        if fields["testRunSteps"] != nil {
            let testStepFields: [[String : AnyObject]] = fields["testRunSteps"] as! Array
        
            for step in testStepFields {
                let tmpStep = TestStepModel()
                tmpStep.extractStep(fromData: step)
                testStepList.append(tmpStep)
            }
        }
    }
}
