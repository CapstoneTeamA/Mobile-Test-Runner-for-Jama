//
//  TestPlanListModel.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

class TestPlanListModel {
    var testPlanList: [TestPlanModel] = []
    
    func extractPlanList(fromData: [[String : AnyObject]]) {
        for plan in fromData {
            let tmpPlan = TestPlanModel()
            tmpPlan.extractPlan(fromData: plan)
            testPlanList.append(tmpPlan)
        }
    }
}
