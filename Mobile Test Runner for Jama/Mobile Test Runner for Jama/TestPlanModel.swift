//
//  TestPlanModel.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

class TestPlanModel {
    var projectId = -1
    var id = -1
    var name = ""
    var archived = false
    
    func extractPlan(fromData: [String: AnyObject]) {
        id = fromData["id"] as! Int
        projectId = fromData["project"] as! Int
        archived = fromData["archived"] as! Bool
        let fields: [String :  AnyObject] = fromData["fields"] as! Dictionary
        name = fields["name"] as! String
        
    }
}
