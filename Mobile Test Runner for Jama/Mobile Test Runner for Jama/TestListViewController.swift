//
//  TestRunListViewController.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

class TestListViewController: UIViewController {
    @IBOutlet weak var testList: UITableView!
    @IBOutlet weak var tmpProjectLabel: UILabel!
    let testPlanList: TestPlanListModel = TestPlanListModel()
    let testCycleList: TestCycleListModel = TestCycleListModel()
    let testRunList:  TestRunListModel = TestRunListModel()
    var projectName = "" //I don't know if we need this but we might want to display it or something so I left it.
    var projectId = -1
    var testCycleId = -1
    var instance = ""
    var username = ""
    var password = ""
    var totalCyclesVisable = 0;
    var selectedPlanIndex = Int.max
    var selectedCycleIndex = Int.max
    var testRunDescription = ""
    enum TestLevel {
        case plan, cycle, run
    }
    var currentTestLevel = TestLevel.plan
    var planId = -1
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.currentTestLevel = .plan
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func getCyclesForPlanOnClick() {
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
                    tmpList.extractCycleList(fromData: unwrappedData, parentId: self.planId)
                    if tmpList.testCycleList.isEmpty {
                        return
                    }
                    self.testCycleList.testCycleList.append(contentsOf: tmpList.testCycleList)
                    self.totalCyclesVisable = self.testCycleList.testCycleList.count
                    self.testPlanList.testPlanList[self.selectedPlanIndex].numOfCycles = self.totalCyclesVisable
                    self.testList.reloadData()
                    
                    //keep calling api while there are still more cycles
                    if self.testCycleList.testCycleList.count < totalItems {
                        RestHelper.hitEndpoint(atEndpointString: self.buildTestCycleEndpointString() + "&startAt=\(self.testCycleList.testCycleList.count)", withDelegate: self, username: self.username, password: self.password)
                    }
                        
                case .run:
                    let tmpList = TestRunListModel()
                    tmpList.extractRunList(fromData: unwrappedData)
                    if tmpList.testRunList.isEmpty {
                        //TODO: display message for no test runs
                        return
                    }
                    self.testRunList.testRunList.append(contentsOf: tmpList.testRunList)
                    
                    //TODO: once the testRuns view is made we need to reload the data in the view
                    //reload Data in view?
                    
                    //keep calling api while there are still more cycles
                    if self.testRunList.testRunList.count < totalItems {
                        RestHelper.hitEndpoint(atEndpointString: self.buildTestRunEndpointString() + "&startAt=\(self.testRunList.testRunList.count)", withDelegate: self, username: self.username, password: self.password)
                    }

            }
        }
    }
    
    func comparePlans(lhs: TestPlanModel, rhs: TestPlanModel) -> Bool {
        return lhs.name < rhs.name
    }
    
}

extension TestListViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testPlanList.testPlanList.count + testCycleList.testCycleList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        return buildCell(indexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //unselect item
        if indexPath.row == selectedPlanIndex {
            selectedPlanIndex = Int.max
            testCycleList.testCycleList = []
            testList.reloadData()
            return
        }
        //tapped on a cycle do something
        if indexPath.row > selectedPlanIndex && indexPath.row <= selectedPlanIndex + totalCyclesVisable {
            return
        }
        //TODO will need to subtract totalRunsVisable also
        selectedPlanIndex = indexPath.row <= selectedPlanIndex ? indexPath.row : indexPath.row - totalCyclesVisable
        testCycleList.testCycleList = []
        planId = testPlanList.testPlanList[selectedPlanIndex].id
        getCyclesForPlanOnClick()
    }
    
    func buildCell(indexPath: IndexPath) -> UITableViewCell {
        //TODO Need to check if the cell needs to be a test run
        
        //This needs to be a testCycle cell
        if indexPath.row > selectedPlanIndex && indexPath.row <= selectedPlanIndex + totalCyclesVisable {
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TestCycleCell")
            cell.textLabel?.text = self.testCycleList.testCycleList[indexPath.row - self.selectedPlanIndex - 1].name
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 20.0)
            cell.backgroundColor = UIColor(colorLiteralRed: 0xF5/0xFF, green: 0xF5/0xFF, blue: 0xF5/0xFF, alpha: 1)
            cell.indentationLevel = 1
            cell.indentationWidth = 15.0
            return cell
        }
        //Otherwise just the cell needs to be a test plan cell
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TestPlanCell")
        let testPlanIndex = indexPath.row > selectedPlanIndex ? indexPath.row - testPlanList.testPlanList[selectedPlanIndex].numOfCycles : indexPath.row
        cell.textLabel?.text = testPlanList.testPlanList[testPlanIndex].name
        cell.textLabel?.textAlignment = .left
        cell.backgroundColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 20.0)
        return cell
    }

}
