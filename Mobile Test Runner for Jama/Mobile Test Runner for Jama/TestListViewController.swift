//
//  TestRunListViewController.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

class TestListViewController: UIViewController {
    var projectName = "" //I don't know if we need this but we might want to display it or something so I left it.
    var projectId = -1
    var instance = ""
    var username = ""
    var password = ""
    
    @IBOutlet weak var testList: UITableView!
    let testPlanList: TestPlanListModel = TestPlanListModel()
    @IBOutlet weak var tmpProjectLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let endpoint = buildTestPlanEndpointString()
        RestHelper.hitEndpoint(atEndpointString: endpoint, withDelegate: self, httpMethod: "Get", username: username, password: password)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildTestPlanEndpointString() -> String {
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
            
   //         self.testPlanList.testPlanList.sort(by: self.comparePlans(lhs:rhs:))
            
            //reload Data in view
            self.testList.reloadData()
            //keep calling api while there is still more plans to get
            if self.testPlanList.testPlanList.count < totalItems {
                RestHelper.hitEndpoint(atEndpointString: self.buildTestPlanEndpointString() + "&startAt=\(self.testPlanList.testPlanList.count)", withDelegate: self, username: self.username, password: self.password)
            }
            
        }
    }
    
    func comparePlans(lhs: TestPlanModel, rhs: TestPlanModel) -> Bool {
        return lhs.name < rhs.name
    }
}

extension TestListViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testPlanList.testPlanList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        return buildCell(indexPath: indexPath)
    }
    
    func buildCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TestPlanCell")
        
        cell.textLabel?.text = testPlanList.testPlanList[indexPath.row].name
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 20.0)
        return cell
    }

}
