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
        
        //encode the username and password into the 64bit string expected for basic auth
        guard let base64LoginString = loginData?.base64EncodedString() else {
            print("Could not encode user info for test")
            return URLRequest(url: url)
        }
        //Add the request http header fields
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    static func prepareHttpRequest(atEndpointString: String, username: String, password: String, httpMethod: String = "Get") -> URLRequest? {
        //Build URL from endpoint string or return nil
        guard let url = URL(string: atEndpointString) else {
            print("Bad string for url")
            return nil
        }
        
        //Get a URLRequest with basic auth and given endpoint
        var request = RestHelper.basicAuth(url: url, username: username, password: password)
        request.httpMethod = httpMethod
        return request
    }
    
    static func hitEndpoint(atEndpointString: String, withDelegate: EndpointDelegate, httpMethod : String = "Get", username: String, password: String) {
        guard let request = prepareHttpRequest(atEndpointString: atEndpointString, username: username, password: password, httpMethod: httpMethod) else {
            return
        }
        let session = URLSession.shared
        
        //Asynchronous task to run in the background that hits the delegate when it finishes if successful.
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
                //I believe the jsonData will always be a dictionary.
                guard let jsonData = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert to JSON")
                        return
                }
                //Get the meta section of the response to get the status.
                var meta: [String:AnyObject] = jsonData["meta"] as! Dictionary
                let status = meta["status"] as! String
                
                //If user isn't authorized show an auth failed message.
                if (status == "Unauthorized") {
                    endpointData = []
                    endpointData.append(["Unauthorized": status as AnyObject])
                    
                } else {
                    //user authorized, parse data section of response and print greeting
                    if jsonData["data"] is Dictionary<String,AnyObject> {
                        //this is needed for endpoints that only return a single object e.g. currentUser
                        //as these are not returned wrapped in an array.
                        endpointData.append(jsonData["data"] as! Dictionary)
                    } else {
                        endpointData = jsonData["data"] as! Array
                    }
                }
                //Call on the provided delegate
                withDelegate.didLoadEndpoint(data: endpointData)
                
            } catch {
                print("error trying to convert to json")
            }
        }
        task.resume()
    }
}
