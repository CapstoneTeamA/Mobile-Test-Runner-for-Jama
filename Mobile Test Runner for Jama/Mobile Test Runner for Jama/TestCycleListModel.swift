//
//  TestCycleListModel.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

class TestCycleListModel {
    var testCycleList: [TestCycleModel] = []
    let testCycleItemTypeId = 36 //ID in the jama system for items of the type TestCycle
    
    func extractCycleList(fromData: [[String : AnyObject]], parentId: Int) {
        for cycle in fromData {
            let fields: [String : AnyObject] = cycle["fields"] as! Dictionary
            if cycle["itemType"] as! Int != testCycleItemTypeId || fields["testPlan"] as! Int != parentId{
                break
            }
            let tmpCycle = TestCycleModel()
            tmpCycle.extractCycle(fromData: cycle)
            testCycleList.append(tmpCycle)
        }
    }
}
