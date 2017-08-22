//
//  RestHelper.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

protocol EndpointDelegate {
    func didLoadEndpoint(data: [[String: AnyObject]]?, totalItems: Int, timestamp: String)
}

class RestHelper {
    
    static func getCurrentTimestampString() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSS"
        let timestamp = formatter.string(from: now)
        return timestamp
    }
    
    static func getEndpointString(method: String, endpoint: String) -> String{
        //Get the Endpoints plist, using the http method string select the correct dictionary of endpoints, then grab and return the endpoint.
        if let plist = Bundle.main.path(forResource: "Endpoints", ofType: "plist"), let dict = NSDictionary(contentsOfFile: plist) as? [String : AnyObject] {
            guard let httpDict: [String : AnyObject] = dict[method] as? Dictionary else {
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
    
    static func basicAuth(url: URL, username: String, password: String) -> URLRequest {
        var request = URLRequest(url: url)
        let loginString = username + ":" + password
        let loginData = loginString.data(using: String.Encoding.utf8)
        
        //Encode the username and password into the 64bit string expected for basic auth
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
    
    static func processRestJson(jsonData: [String : Any] ) -> ([[String : AnyObject]], Int) {
        var totalItems: Int = 0
        var endpointData: [[String : AnyObject]]  = []
        var meta: [String:AnyObject] = jsonData["meta"] as! Dictionary
        let status = meta["status"] as! String
        if let pageInfo: [String : AnyObject] = meta["pageInfo"] as? Dictionary {
            totalItems = pageInfo["totalResults"] as! Int
        } else {
            totalItems = 1
        }
        
        //If user isn't authorized show an auth failed message.
        if (status == "Unauthorized") {
            endpointData = []
            endpointData.append(["Unauthorized": status as AnyObject])
            
        } else {
            //user authorized, parse data section of response and print greeting
            if jsonData["data"] is Dictionary<String,AnyObject> {
                //This is needed for endpoints that only return a single object e.g. currentUser
                //as these are not returned wrapped in an array.
                endpointData.append(jsonData["data"] as! Dictionary)
            } else {
                if jsonData["data"] != nil {
                endpointData = jsonData["data"] as! Array
                }
                else {
                    return ([],0)
                }
            }
        }
        return (endpointData, totalItems)
    }
    
    static func hitEndpoint(atEndpointString: String, withDelegate: EndpointDelegate, httpMethod : String = "Get", username: String, password: String, timestamp: String) {
        guard let request = prepareHttpRequest(atEndpointString: atEndpointString, username: username, password: password, httpMethod: httpMethod) else {
            return
        }
        let session = URLSession.shared

        //Asynchronous task to run in the background that hits the delegate when it finishes if successful.
        let task = session.dataTask(with: request) {
            (data,response,error) in
            var endpointData: [[String : AnyObject]]  = []
            guard error == nil else {
                print("error calling endpoint")
                endpointData.append(["Unauthorized": "Unauthorized" as AnyObject])
                withDelegate.didLoadEndpoint(data: endpointData, totalItems: 0, timestamp: timestamp)
                return
            }
            guard let responseData = data else {
                withDelegate.didLoadEndpoint(data: nil, totalItems: 0, timestamp: timestamp)
                return
            }
            
            //Parsing json
            do {
                //I believe the jsonData will always be a dictionary.
                guard let jsonData = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert to JSON")
                        return
                }
                //Get the meta section of the response to get the status.
                var totalItems = 0
                (endpointData, totalItems) = self.processRestJson(jsonData: jsonData)
                
                //Call on the provided delegate.
                withDelegate.didLoadEndpoint(data: endpointData, totalItems: totalItems, timestamp: timestamp)
                
            } catch {
                print("error trying to convert to json")
            }
        }
        task.resume()
    }
    
    static func hitPutEndpoint(atEndpointString: String, withDelegate: RestPutDelegate, username: String, password: String, httpBodyData: Data) {
        var request = RestHelper.prepareHttpRequest(atEndpointString: atEndpointString, username: username, password: password, httpMethod: "PUT")
        
        let session = URLSession.shared
        var dataTask: URLSessionDataTask!
        request?.httpBody = httpBodyData
            
        dataTask = session.dataTask(with: request!, completionHandler: {
            (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!) //Grab this and display to the user.
                withDelegate.didPutTestRun(responseCode: (httpResponse?.statusCode)!)
            }
        })
        dataTask.resume()
    }
}
