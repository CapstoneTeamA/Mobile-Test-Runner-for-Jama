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
    @IBOutlet weak var noPlansImage: UIImageView!
    @IBOutlet weak var noPlansLabel: UILabel!
    let testPlanList: TestPlanListModel = TestPlanListModel()
    let testCycleList: TestCycleListModel = TestCycleListModel()
    let testRunList:  TestRunListModel = TestRunListModel()
    var testRun: TestRunModel = TestRunModel()
    var currentUser: UserModel!
    var projectId = -1
    var selectedPlanId = -1
    var selectedTestCycleId = -1
    let largeNumber = 1000000
    var instance = ""
    var username = ""
    var password = ""
    var selectedPlanIndex = 1000000
    var selectedCycleIndex = 1000000
    var selectedCycleTableViewIndex = -1
    var totalRunsReturnedFromServer = 0
    var currentTestLevel = TestLevel.plan
    enum TestLevel {
        case plan, cycle, run
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.noPlansImage.isHidden = true
        self.noPlansLabel.isHidden = true
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
        cycleEndpoint = cycleEndpoint.replacingOccurrences(of: "{planId}", with: "\(selectedPlanId)")
        return cycleEndpoint
    }
    
    func getRunsForCycleOnClick(){
        self.currentTestLevel = .run
        let runEndpoint = buildTestRunEndpointString()
        RestHelper.hitEndpoint(atEndpointString: runEndpoint, withDelegate: self, httpMethod: "Get", username: username, password: password)
    }
    
    func buildTestRunEndpointString() -> String {
        var runEndpoint = RestHelper.getEndpointString(method: "Get", endpoint: "TestRuns")
        runEndpoint = "https://" + instance + "." + runEndpoint
        runEndpoint = runEndpoint.replacingOccurrences(of: "{testCycleId}", with: "\(selectedTestCycleId)")
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
                        self.testList.isUserInteractionEnabled = false
                        self.testList.separatorColor = UIColor.white
                        self.noPlansImage.isHidden = false
                        self.noPlansLabel.isHidden = false
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
                    tmpList.extractCycleList(fromData: unwrappedData, parentId: self.selectedPlanId)
                    //if there are no cycles, display an empty cycle with the default value set to No Cycles Found, made unclickable in the buildCycleCell function below
                    if tmpList.testCycleList.isEmpty {
                        let emptyCycle = TestCycleModel();
                        tmpList.testCycleList.insert(emptyCycle, at: 0)
                    }
                    
                    self.testCycleList.testCycleList.append(contentsOf: tmpList.testCycleList)
                    self.testList.reloadData()
                    
                    //keep calling api while there are still more cycles
                    if self.testCycleList.testCycleList.count < totalItems {
                        RestHelper.hitEndpoint(atEndpointString: self.buildTestCycleEndpointString() + "&startAt=\(self.testCycleList.testCycleList.count)", withDelegate: self, username: self.username, password: self.password)
                }
                case .run:
                    let tmpList = TestRunListModel()
                    tmpList.extractRunList(fromData: unwrappedData, parentId: self.selectedTestCycleId)
                    
                    //Filter the runs returned from the API to select the assignedTo value is the current user's id
                    self.totalRunsReturnedFromServer += tmpList.testRunList.count
                    
                    for run in tmpList.testRunList {
                        if run.assignedTo == self.currentUser.id && run.status != "BLOCKED" && run.status != "PASSED" && run.status != "FAILED"  {
                            self.testRunList.testRunList.append(run)
                        }
                    }
                    ////if there are no runs, display an empty run with the default value set to No Runs Found, made unclickable and with no number in the buildRunCell function below
                   
                    self.testList.reloadData()
                    //keep calling api while there are still more runs
                    if self.totalRunsReturnedFromServer < totalItems {
                        RestHelper.hitEndpoint(atEndpointString: self.buildTestRunEndpointString() + "&startAt=\(self.totalRunsReturnedFromServer)", withDelegate: self, username: self.username, password: self.password)
                        return
                    }
                    
                    if self.testRunList.testRunList.isEmpty {
                            let emptyRun = TestRunModel()
                            self.testRunList.testRunList.insert(emptyRun, at: 0)
                    }
                    self.testList.reloadData()
            }
        }
    }
    
    func comparePlans(lhs: TestPlanModel, rhs: TestPlanModel) -> Bool {
        return lhs.name < rhs.name
    }
}

extension TestListViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numOfRun = selectedCycleIndex == largeNumber ? 0 : testRunList.testRunList.count
        let numOfCycle = selectedPlanIndex == largeNumber ? 0 : testCycleList.testCycleList.count
        return testPlanList.testPlanList.count + numOfCycle + numOfRun
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = buildCell(indexPath: indexPath)
        cell.selectionStyle = .none
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.tintColor = UIColor.black
        cell?.setHighlighted(false, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.tintColor = UIColor.clear
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //If we unselect a test plan or cycle return
        
        if unselectTestPlan(indexPath: indexPath) || unselectTestCycle(indexPath: indexPath) {
            return
        }
        tableView.cellForRow(at: indexPath)?.tintColor = UIColor.black
        tableView.deselectRow(at: indexPath, animated: true)
        //If the user taps a test run, go to the index screen for that test run
        if tableView.cellForRow(at: indexPath)?.reuseIdentifier == "TestRunCell" {
            
            let runViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TestRunIndex") as! TestRunIndexViewController
            
            let currentRunIndex = indexPath.row - selectedCycleTableViewIndex - 1
            runViewController.testRun = self.testRunList.testRunList[currentRunIndex]
            runViewController.username = username
            runViewController.password = password
            runViewController.instance = instance
            runViewController.preserveCurrentRunStatus()
            self.navigationController?.pushViewController(runViewController, animated: true)
            return
        }
        //If the user taps a test cycle in the table
        if tableView.cellForRow(at: indexPath)?.reuseIdentifier == "TestCycleCell" {
            didTapTestCycleCell(indexPath: indexPath)
            getRunsForCycleOnClick()
            return
        }
        didTapTestPlanCell(indexPath: indexPath)
        getCyclesForPlanOnClick()
    }
    
    func buildCell(indexPath: IndexPath) -> UITableViewCell {
        //If the cell needs to be a testRun cell
        if indexPath.row > selectedCycleTableViewIndex && indexPath.row <= selectedCycleTableViewIndex + testRunList.testRunList.count {
            return buildTestRunCell(indexPath: indexPath)
        }
        
        //If the cell needs to be a testCycle cell
        if indexPath.row > selectedPlanIndex && indexPath.row <= selectedPlanIndex + testCycleList.testCycleList.count + testRunList.testRunList.count {
            return buildTestCycleCell(indexPath: indexPath)
        }

        //If the cell needs to be a testPlan cell
        return buildTestPlanCell(indexPath: indexPath)
    }
    
    func unselectTestPlan(indexPath: IndexPath) -> Bool {
        //If the user taps the plan that was already selected, empty out the test run and test cycle lists deselect the selectedCycleIndex, selectedCycleTableViewIndex, and selectedPlanIndex and reload the table
        if selectedPlanIndex == indexPath.row {
            selectedPlanIndex = largeNumber
            selectedCycleIndex = largeNumber
            selectedCycleTableViewIndex = largeNumber
            testCycleList.testCycleList = []
            testRunList.testRunList = []
            testList.reloadData()
            return true
        }
        return false
    }
    
    func unselectTestCycle(indexPath: IndexPath) -> Bool {
        //If the user taps the cycle that was already selected, empty out the test run list and deselect the selectedCycleIndex and selectedCycleTableViewIndex and reload the table
        if selectedCycleTableViewIndex == indexPath.row {
            selectedCycleTableViewIndex = largeNumber
            selectedCycleIndex = largeNumber
            testRunList.testRunList = []
            testList.reloadData()
            return true
        }
        return false
    }
    
    func didTapTestCycleCell(indexPath: IndexPath) {
        //Set the selectedCycleIndex based on if the cycle is before or after the currently showing test runs
        if indexPath.row <= selectedCycleTableViewIndex {
            selectedCycleIndex = indexPath.row - selectedPlanIndex - 1
            selectedCycleTableViewIndex = indexPath.row
        } else {
            selectedCycleIndex = indexPath.row - selectedPlanIndex - testRunList.testRunList.count - 1
            selectedCycleTableViewIndex = indexPath.row - testRunList.testRunList.count
        }
                
        //Empty out the previously selected test cycle's run list
        testRunList.testRunList = []
        totalRunsReturnedFromServer = 0
        selectedTestCycleId = testCycleList.testCycleList[selectedCycleIndex].id
    }
    
    func didTapTestPlanCell(indexPath: IndexPath) {
        //The user tapped a test plan, deselect the selectedCycleIndex and selectedCycleTableViewIndex, then set the new selectedPlanIndex
        selectedCycleTableViewIndex = largeNumber
        selectedCycleIndex = largeNumber
        selectedPlanIndex = indexPath.row <= selectedPlanIndex ? indexPath.row : indexPath.row - testCycleList.testCycleList.count - testRunList.testRunList.count
        
        //Empty out the previous test plan's cycle list and run list
        testCycleList.testCycleList = []
        testRunList.testRunList = []
        selectedPlanId = testPlanList.testPlanList[selectedPlanIndex].id
    }
    
    func buildTestRunCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TestRunCell")
        let currentRunIndex = indexPath.row - selectedCycleTableViewIndex - 1
        
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 20.0)
        cell.backgroundColor = UIColor.white
        cell.indentationLevel = 1
        if self.testRunList.testRunList[0].name == "No Runs Found" {
            cell.isUserInteractionEnabled = false
            cell.textLabel?.text = self.testRunList.testRunList[currentRunIndex].name
        } else {
            cell.textLabel?.text = "\(currentRunIndex + 1). " + self.testRunList.testRunList[currentRunIndex].name
            
            cell.accessoryType = .disclosureIndicator
        
        }
        return cell
    }
    
    func buildTestCycleCell(indexPath: IndexPath) -> UITableViewCell {
        //Find the index into the testCycleList to get the cycle name for the current cell
        var currentCycleIndex = largeNumber
        if indexPath.row <= selectedCycleTableViewIndex {
            currentCycleIndex = indexPath.row - selectedPlanIndex - 1
        } else {
            currentCycleIndex = indexPath.row - selectedPlanIndex - testRunList.testRunList.count - 1
        }
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TestCycleCell")
        
        cell.textLabel?.text = self.testCycleList.testCycleList[currentCycleIndex].name
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 20.0)
        
        //If cycle's cell is selected change the background color
        if selectedCycleTableViewIndex != indexPath.row {
            cell.backgroundColor = UIColor(colorLiteralRed: 0xE5/0xFF, green: 0xE5/0xFF, blue: 0xE5/0xFF, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(colorLiteralRed: 0xFF/0xFF, green: 0xFD/0xFF, blue: 0xCF/0xFF, alpha: 1)
            
        }
        cell.indentationLevel = 1
        cell.indentationWidth = 15.0
        if(self.testCycleList.testCycleList[0].name == "No Cycles Found")
        {
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func buildTestPlanCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TestPlanCell")
        
        //Find the index into the testPlanList to get the plan name
        var currentPlanIndex = largeNumber
        if indexPath.row <= selectedPlanIndex {
            currentPlanIndex = indexPath.row
        } else {
            currentPlanIndex = indexPath.row - testCycleList.testCycleList.count - testRunList.testRunList.count
        }
        cell.textLabel?.text = testPlanList.testPlanList[currentPlanIndex].name
        cell.textLabel?.textAlignment = .left
        //If the plan's cell is selected change the background color
    
        cell.backgroundColor = UIColor(colorLiteralRed: 0x76/0xFF, green: 0xD3/0xFF, blue: 0xF5/0xFF, alpha: 1)
        
        if selectedPlanIndex != indexPath.row {
                cell.backgroundColor = UIColor.lightGray
        }
        
        cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 20.0)
        return cell
    }

}
