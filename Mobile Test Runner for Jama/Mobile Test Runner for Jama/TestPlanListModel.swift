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
    
    func extractPlanList(fromData: [[String : AnyObject]], itemTypeId: Int) {
        for plan in fromData {
            if plan["itemType"] as! Int != itemTypeId {
                break
            }
            let tmpPlan = TestPlanModel()
            tmpPlan.extractPlan(fromData: plan)
            testPlanList.append(tmpPlan)
        }
    }
}
