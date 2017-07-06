//
//  RestHelper.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

class RestHelper {
    
    static func getEndpointString(method: String, endpoint: String) -> String{
        //Get the Endpoints plist, using the http method string select the correct dictionary of endpoints, then grab and return the endpoint
        if let plist = Bundle.main.path(forResource: "Endpoints", ofType: "plist"), let dict = NSDictionary(contentsOfFile: plist) as? [String : AnyObject] {
            guard let httpDict : [String : AnyObject] = dict[method] as? Dictionary else {
                print("HTTP method does not exist. Ensure method is all caps")
                return ""
            }
            
            guard let endpoint = httpDict[endpoint] as? String else {
                print("Endpoint key does not exist. Double check spelling")
                return ""
            }
            return endpoint
        }
            return ""
        }
    
}
