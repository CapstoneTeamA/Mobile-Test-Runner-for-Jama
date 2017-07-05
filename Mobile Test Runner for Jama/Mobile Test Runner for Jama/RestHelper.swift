//
//  RestHelper.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

protocol EndpointDelegate {
    func didLoadEndpoint(data: [[String: AnyObject]]?)
}

class RestHelper {
    
    static func basicAuth(url: URL, username: String, password: String) -> URLRequest {
        var request = URLRequest(url: url)
        let loginString = username + ":" + password
        let loginData = loginString.data(using: String.Encoding.utf8)
        guard let base64LoginString = loginData?.base64EncodedString() else {
            print("Could not encode user info for test")
            return URLRequest(url: url)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    static func hitEndpoint(atEndpointString: String, withDelegate: EndpointDelegate, httpMethod : String = "Get", username: String, password: String) {
        //Create a url from the endpoint string
        guard let url = URL(string: atEndpointString) else {
            print("Bad string for url")
            return
        }
        
        //Get a URLRequest with basic auth
        var request = RestHelper.basicAuth(url: url, username: username, password: password)
        request.httpMethod = httpMethod
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) {
            (data,response,error) in
            guard error == nil else {
                print("error calling endpoint")
                print(error as Any)
                return
            }
            guard let responseData = data else {
                print("Error did not recieve data")
                return
            }
            var endpointData : [[String: AnyObject]]  = []
            //Parsing json
            do {
                guard let jsonData = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert to JSON")
                        return
                }
                //Get the meta section of the response to get the status
                var meta: [String:AnyObject] = jsonData["meta"] as! Dictionary
                let status = meta["status"] as! String
                
                //If user isn't authorized show an auth failed message
                if (status == "Unauthorized") {
                    endpointData = []
                    
                } else {
                    //user authorized, parse data section of response and print greeting
                    endpointData = jsonData["data"] as! Array
                }
                withDelegate.didLoadEndpoint(data: endpointData)
                
            } catch {
                print("error trying to convert to json")
            }
        }
        task.resume()
    }
}
