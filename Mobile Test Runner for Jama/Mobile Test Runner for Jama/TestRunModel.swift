//
//  TestRunModel.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

class TestRunModel {
    var description = ""
    var id = -1
    var name = ""
    
    func extractPlan(fromData: [String: AnyObject]) {
        id = fromData["id"] as! Int
        let fields: [String :  AnyObject] = fromData["fields"] as! Dictionary
        name = fields["name"] as! String
        description = fields["description"] as! String
    }
}
