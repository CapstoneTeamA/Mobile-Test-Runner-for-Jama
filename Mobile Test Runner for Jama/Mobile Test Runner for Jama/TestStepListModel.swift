//
//  TestStepListModel.swift
//  Mobile Test Runner for Jama
//
//  Created by Meghan McBee on 7/31/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

class TestStepListModel {
    var testStepList: [TestStepModel] = []
    var parentRunId: Int = -1
    
    func extractStepList(fromData: [String : AnyObject], parentId: Int) {
        parentRunId = parentId
        let fields: [String : AnyObject] = fromData["fields"] as! Dictionary
        let testStepFields: [[String : AnyObject]] = fields["testRunSteps"] as! [[String : AnyObject]]
        
        for step in testStepFields {
            let tmpStep = TestStepModel()
            tmpStep.extractStep(fromData: step)
            testStepList.append(tmpStep)
        }
    }
}
