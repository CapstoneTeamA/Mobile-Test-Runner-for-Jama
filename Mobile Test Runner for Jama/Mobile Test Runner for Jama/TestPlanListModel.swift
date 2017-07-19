//
//  TestPlanListModel.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

class TestPlanListModel {
    var testPlanList : [TestPlanModel] = []
    
    func extractTestPlanList(fromData: [[String : AnyObject]]) {
        for testPlanData in fromData {
            let tmpPlan = TestPlanModel()
            tmpPlan.extractTestPlan(fromData: testPlanData)
            testPlanList.append(tmpPlan)
            
        }
    }
}
