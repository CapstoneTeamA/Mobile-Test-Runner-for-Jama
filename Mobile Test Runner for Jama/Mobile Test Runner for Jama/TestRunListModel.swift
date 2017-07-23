//
//  TestRunListModel.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

class TestRunListModel {
    var testRunList: [TestRunModel] = []
    
    func extractRunList(fromData: [[String : AnyObject]]) {
        for run in fromData {
            if run["itemType"] as! Int != 37 {
                break
            }
            let tmpRun = TestRunModel()
            tmpRun.extractPlan(fromData: run)
            testRunList.append(tmpRun)
        }
    }
}
