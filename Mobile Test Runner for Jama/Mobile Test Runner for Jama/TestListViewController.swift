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
    var testCycleId = -1
    var instance = ""
    var username = ""
    var password = ""
    var testRunDescription = ""
    enum TestLevel {
        case plan, cycle, run
    }
    var currentTestLevel = TestLevel.plan
    var planId = -1
    
    @IBOutlet weak var testList: UITableView!
    @IBOutlet weak var tmpProjectLabel: UILabel!
    let testPlanList: TestPlanListModel = TestPlanListModel()
    let testCycleList: TestCycleListModel = TestCycleListModel()
    let testRunList:  TestRunListModel = TestRunListModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.currentTestLevel = .plan
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
    
    // TO DO: attach this action to the selected plan button
    func getCyclesForPlanOnClick() {
        // TO DO: get plan id for chosen testplanmodel somehow
        planId = 3334
        
        self.currentTestLevel = .cycle
        let cycleEndpoint = buildTestCycleEndpointString()
        RestHelper.hitEndpoint(atEndpointString: cycleEndpoint, withDelegate: self, httpMethod: "Get", username: username, password: password)
    }
    
    func buildTestCycleEndpointString() -> String {
        var cycleEndpoint = RestHelper.getEndpointString(method: "Get", endpoint: "TestCycles")
        cycleEndpoint = "https://" + instance + "." + cycleEndpoint
        cycleEndpoint = cycleEndpoint.replacingOccurrences(of: "{planId}", with: "\(planId)")
        return cycleEndpoint
    }
    
    func getRunsForCycleOnClick(){
        // TODO: get test cycle id for chosen testplan
        testCycleId = 6838
        self.currentTestLevel = .run
        let runEndpoint = buildTestRunEndpointString()
        RestHelper.hitEndpoint(atEndpointString: runEndpoint, withDelegate: self, httpMethod: "Get", username: username, password: password)
    }
    
    func buildTestRunEndpointString() -> String {
        var runEndpoint = RestHelper.getEndpointString(method: "Get", endpoint: "TestRuns")
        runEndpoint = "https://" + instance + "." + runEndpoint
        runEndpoint = runEndpoint.replacingOccurrences(of: "{testCycleId}", with: "\(testCycleId)")
        return runEndpoint
    }




    @IBAction func touchedLogoutButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

}

extension TestListViewController: EndpointDelegate {
    func didLoadEndpoint(data: [[String : AnyObject]]?, totalItems: Int) {
        guard let unwrappedData = data else {
            //Do and Error work for a nil data returned from the endpoint
            return
        }
        DispatchQueue.main.async {
            switch self.currentTestLevel {
                
                case .plan:
                    let tmpList = TestPlanListModel()
                    tmpList.extractPlanList(fromData: unwrappedData)
                    if tmpList.testPlanList.isEmpty {
                        return
                    }
                    self.testPlanList.testPlanList.append(contentsOf: tmpList.testPlanList)
                    //self.testPlanList.testPlanList.sort(by: self.comparePlans(lhs:rhs:))
            
                    //reload Data in view
                    self.testList.reloadData()
                    //keep calling api while there is still more plans to get
                    if self.testPlanList.testPlanList.count < totalItems {
                        RestHelper.hitEndpoint(atEndpointString: self.buildTestPlanEndpointString() + "&startAt=\(self.testPlanList.testPlanList.count)", withDelegate: self, username: self.username, password: self.password)
                    }
                
                case .cycle:
                    let tmpList = TestCycleListModel()
                    tmpList.extractCycleList(fromData: unwrappedData)
                    if tmpList.testCycleList.isEmpty {
                        return
                    }
                    self.testCycleList.testCycleList.append(contentsOf: tmpList.testCycleList)

                    //reload Data in view? self.testCycle.reloadData()
                
                    //keep calling api while there are still more cycles
                    if self.testCycleList.testCycleList.count < totalItems {
                        RestHelper.hitEndpoint(atEndpointString: self.buildTestCycleEndpointString() + "&startAt=\(self.testCycleList.testCycleList.count)", withDelegate: self, username: self.username, password: self.password)
                    }
                        
                case .run:
                    let _ = 0  //TO DO: Add call for test runs here and remove this line

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
