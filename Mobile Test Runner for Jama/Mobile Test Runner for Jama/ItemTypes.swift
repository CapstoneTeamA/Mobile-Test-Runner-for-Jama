//
//  ItemTypes.swift
//  Mobile Test Runner for Jama
//
//  Created by Meghan McBee on 9/4/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

class ItemTypes {
    
    var endpointString: String = ""
    var totalItemTypesReturned: Int = 0
    var username: String = ""
    var password: String = ""
    
    let planKey: String = "TSTPL"
    let cycleKey: String = "TSTCY"
    let runKey: String = "TSTRN"
    var planId: Int = -1
    var cycleId: Int = -1
    var runId: Int = -1

    // Build endpoint string and call API to get instance-specific item type ids
    func getItemIds(instance: String, username: String, password: String) {
        self.username = username
        self.password = password
        
        endpointString = RestHelper.getEndpointString(method: "Get", endpoint: "ItemTypes")
        endpointString = "https://" + instance + "." + endpointString
        RestHelper.hitEndpoint(atEndpointString: endpointString, withDelegate: self, username: username, password: password, timestamp: RestHelper.getCurrentTimestampString())
    }
    
    // Check that all desired item types were found and saved
    func didNotFindAllTypes() -> Bool {
        return planId < 0 || cycleId < 0 || runId < 0
    }
    
    // Only save item type ids for plan, cycle, and run
    func extractItemTypes(fromData: [[String : AnyObject]]) {
        for item in fromData {
            if item["typeKey"] as! String == planKey {
                planId = item["id"] as! Int
            } else if item["typeKey"] as! String == cycleKey {
                cycleId = item["id"] as! Int
            } else if item["typeKey"] as! String == runKey {
                runId = item["id"] as! Int
            }
            self.totalItemTypesReturned += 1
            
            // Stop checking item types once plan, cycle, and run are found
            if !didNotFindAllTypes() {
                return
            }
        }
    }
    
}

extension ItemTypes: EndpointDelegate {
    
    func didLoadEndpoint(data: [[String : AnyObject]]?, totalItems: Int, timestamp: String) {
        guard let unwrappedData = data else {
            return
        }
        DispatchQueue.main.async {
            self.extractItemTypes(fromData: unwrappedData)
            
            //Keep calling API if desired types weren't found in first batch and there are more types to check
            if self.totalItemTypesReturned < totalItems && self.didNotFindAllTypes() {
                RestHelper.hitEndpoint(atEndpointString: self.endpointString + "&startAt=\(self.totalItemTypesReturned)", withDelegate: self, username: self.username, password: self.password, timestamp: RestHelper.getCurrentTimestampString())
            }
        }
    }
}
