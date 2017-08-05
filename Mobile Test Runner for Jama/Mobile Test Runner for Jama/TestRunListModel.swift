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
    let testRunItemTypeId = 37 //Id in the jama system for items of type TestPlan
    
    func extractRunList(fromData: [[String : AnyObject]], parentId: Int) {
        for run in fromData {
            let fields: [String : AnyObject] = run["fields"] as! Dictionary
            if run["itemType"] as! Int != testRunItemTypeId || fields["testCycle"] as! Int != parentId{
                break
            }
            //possible statuses are NOT_RUN, INPROGRESS, BLOCKED, PASSED, FAILED
            if fields["testRunStatus"] as! String == "NOT_RUN" || fields["testRunStatus"] as! String == "INPROGRESS" {
            let tmpRun = TestRunModel()
            tmpRun.extractRun(fromData: run)
            testRunList.append(tmpRun)
            }
        }
    }
}
