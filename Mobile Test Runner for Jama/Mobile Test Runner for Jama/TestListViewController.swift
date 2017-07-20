//
//  TestRunListViewController.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

class TestListViewController: UIViewController {
    var projectName = ""
    var projectId = -1
    var instance = ""
    var username = ""
    var password = ""
    
    let testPlanList: TestPlanListModel = TestPlanListModel()
    @IBOutlet weak var tmpProjectLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let endpoint = buildEndpointString()
        RestHelper.hitEndpoint(atEndpointString: endpoint, withDelegate: self, httpMethod: "Get", username: username, password: password)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildEndpointString() -> String {
        var endpoint = RestHelper.getEndpointString(method: "Get", endpoint: "TestPlans")
        endpoint = "https://" + instance + "." + endpoint
        endpoint = endpoint.replacingOccurrences(of: "{projectId}", with: "\(projectId)")
        return endpoint
    }

}

extension TestListViewController: EndpointDelegate {
    func didLoadEndpoint(data: [[String : AnyObject]]?, totalItems: Int) {
        guard let unwrappedData = data else {
            //Do and Error work for a nil data returned from the endpoint
            return
        }
        DispatchQueue.main.async {
            let tmpList = TestPlanListModel()
            tmpList.extractPlanList(fromData: unwrappedData)
            self.testPlanList.testPlanList.append(contentsOf: tmpList.testPlanList)
            
            self.testPlanList.testPlanList.sort(by: self.comparePlans(lhs:rhs:))
            
            
            //reload Data
            
        }
    }
    
    func comparePlans(lhs: TestPlanModel, rhs: TestPlanModel) -> Bool {
        return lhs.name < rhs.name
    }
}
