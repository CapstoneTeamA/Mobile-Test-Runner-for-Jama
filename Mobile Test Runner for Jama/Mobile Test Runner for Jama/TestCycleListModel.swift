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
    
    func extractCycleList(fromData: [[String : AnyObject]]) {
        for cycle in fromData {
            let tmpCycle = TestCycleModel()
            tmpCycle.extractCycle(fromData: cycle)
            testCycleList.append(tmpCycle)
        }
    }
}
