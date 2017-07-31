//
//  TestRunModel.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

class TestRunModel {
    var description = ""
    var id = -1
    var name = ""
    var assignedTo = -1
    var testStepList: [TestStepModel] = []
    
    func extractRun(fromData: [String: AnyObject]) {
        id = fromData["id"] as! Int
        let fields: [String :  AnyObject] = fromData["fields"] as! Dictionary
        name = fields["name"] as! String
        let assignedToWrappedValue = fields["assignedTo"]
        if assignedToWrappedValue != nil {
            assignedTo = assignedToWrappedValue as! Int
        }
        description = fields["description"] as! String
        
        //extract the list of steps
        let testStepFields: [[String : AnyObject]] = fields["testRunSteps"] as! [[String : AnyObject]]
        
        for step in testStepFields {
            let tmpStep = TestStepModel()
            tmpStep.extractStep(fromData: step)
            testStepList.append(tmpStep)
        }
    }
/*
    func extractStepList(fromData: [String : AnyObject]) {
        //TODO assign run id
        let fields: [String : AnyObject] = fromData["fields"] as! Dictionary
        let testStepFields: [[String : AnyObject]] = fields["testRunSteps"] as! [[String : AnyObject]]
        
        for step in testStepFields {
            let tmpStep = TestStepModel()
            tmpStep.extractStep(fromData: step)
            testStepList.append(tmpStep)
        }
    }
 */
}
