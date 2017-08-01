//
//  TestStepModel.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

class TestStepModel {
    var action = ""
    var expectedResult = ""
    var notes = ""
    var result = ""
    var status = ""
    
    func extractStep(fromData: [String: AnyObject]) {
        action = fromData["action"] as! String
        expectedResult = fromData["expectedResult"] as! String
        notes = fromData["notes"] as! String
        if fromData["result"] != nil {
            result = fromData["result"] as! String
        }
        status = fromData["status"] as! String
    }
}
