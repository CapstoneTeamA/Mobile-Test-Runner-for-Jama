//
//  TestRunListViewController.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

protocol TestRunDelegate {
    func didUpdateTestRun()
    func removeUpdatedItemFromTable()
}

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
    var totalPlansReturnedFromServer = 0
    var totalCyclesReturnedFromServer = 0
    var currentTestLevel = TestLevel.plan
    var displayTestRunAlert = false
    var updatedRunName = ""
    var selectedRunIndex = -1
    var apiTimestamp = ""
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
        if testPlanList.testPlanList.isEmpty {
            let endpoint = buildTestPlanEndpointString()
            apiTimestamp = RestHelper.getCurrentTimestampString()
            RestHelper.hitEndpoint(atEndpointString: endpoint, withDelegate: self, httpMethod: "Get", username: username, password: password, timestamp: apiTimestamp)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //If a test run has just updated before this view appeared
        if displayTestRunAlert {
            //Alert the user that the update was successful
            let updateSucceededAlert = UIAlertController(title: "Test Run Updated", message: updatedRunName + " was successfully committed.", preferredStyle: UIAlertControllerStyle.alert)
            
            updateSucceededAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {
                (action: UIAlertAction!) in
                _ = ""
            }))
            self.present(updateSucceededAlert, animated: true, completion: nil)
        }
        //Unset the flag for test run updates.
        displayTestRunAlert = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
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
        apiTimestamp = RestHelper.getCurrentTimestampString()
        RestHelper.hitEndpoint(atEndpointString: cycleEndpoint, withDelegate: self, httpMethod: "Get", username: username, password: password, timestamp: apiTimestamp)
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
        apiTimestamp = RestHelper.getCurrentTimestampString()
        RestHelper.hitEndpoint(atEndpointString: runEndpoint, withDelegate: self, httpMethod: "Get", username: username, password: password, timestamp: apiTimestamp)
    }
    
    func buildTestRunEndpointString() -> String {
        var runEndpoint = RestHelper.getEndpointString(method: "Get", endpoint: "TestRuns")
        runEndpoint = "https://" + instance + "." + runEndpoint
        runEndpoint = runEndpoint.replacingOccurrences(of: "{testCycleId}", with: "\(selectedTestCycleId)")
        return runEndpoint
    }
    
    func scrollToLastRow() {
        let numberOfSections =  self.testList.numberOfSections
        let numberOfRows = self.testList.numberOfRows(inSection: numberOfSections - 1)
        let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
        self.testList.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }

    @IBAction func touchedLogoutButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension TestListViewController: EndpointDelegate {
    func didLoadEndpoint(data: [[String : AnyObject]]?, totalItems: Int, timestamp: String) {
        guard let unwrappedData = data else {
            return
        }
        DispatchQueue.main.async {
            switch self.currentTestLevel {
                case .plan:
                    if timestamp == self.apiTimestamp {
                        let tmpList = TestPlanListModel()
                        tmpList.extractPlanList(fromData: unwrappedData)
                    
                        self.totalPlansReturnedFromServer += tmpList.testPlanList.count
                    
                        for plan in tmpList.testPlanList {
                            if plan.archived == false {
                                self.testPlanList.testPlanList.append(plan)
                            }
                        }
                        //Reload Data in view
                        self.testList.reloadData()
                    
                        //Keep calling api while there is still more plans to get
                        if self.totalPlansReturnedFromServer < totalItems {
                            RestHelper.hitEndpoint(atEndpointString: self.buildTestPlanEndpointString() + "&startAt=\(self.testPlanList.testPlanList.count)", withDelegate: self, username: self.username, password: self.password, timestamp: timestamp)
                        }
                    
                        //If there are no plans show the No Plans image and label
                        if self.testPlanList.testPlanList.isEmpty {
                            self.testList.isUserInteractionEnabled = false
                            self.testList.separatorColor = UIColor.white
                            self.noPlansImage.isHidden = false
                            self.noPlansLabel.isHidden = false
                            return
                        }
                    }
                case .cycle:
                    let tmpList = TestCycleListModel()
                    if timestamp == self.apiTimestamp {
                        tmpList.extractCycleList(fromData: unwrappedData, parentId: self.selectedPlanId)
                        self.totalCyclesReturnedFromServer += tmpList.testCycleList.count
                    
                        self.testCycleList.testCycleList.append(contentsOf: tmpList.testCycleList)
                        self.testList.reloadData()
                    
                        //Keep calling api while there are still more cycles
                        if self.totalCyclesReturnedFromServer < totalItems {
                            RestHelper.hitEndpoint(atEndpointString: self.buildTestCycleEndpointString() + "&startAt=\(self.testCycleList.testCycleList.count)", withDelegate: self, username: self.username, password: self.password, timestamp: timestamp)
                        }
                    
                        //If there are no cycles, display an empty cycle with the default value set to No Cycles Found, made unclickable in the buildCycleCell function below
                        if tmpList.testCycleList.isEmpty && self.testCycleList.testCycleList.isEmpty {
                            let emptyCycle = TestCycleModel();
                            self.testCycleList.testCycleList.insert(emptyCycle, at: 0)
                            self.testList.reloadData()
                        }
                    
                        //At the last test plan, auto scroll down to make the cycle cell visible
                        if self.selectedPlanIndex == self.totalPlansReturnedFromServer - 1 {
                            self.scrollToLastRow()
                        }
                    }
                
                case .run:
                    if timestamp == self.apiTimestamp {
                        let tmpList = TestRunListModel()
                        tmpList.extractRunList(fromData: unwrappedData, parentId: self.selectedTestCycleId)
                        self.totalRunsReturnedFromServer += tmpList.testRunList.count
                    

                    
                    //Filter the runs returned from the API to select the assignedTo value is the current user's id
                    for run in tmpList.testRunList {
                        if run.assignedTo == self.currentUser.id && (run.testStatus == "NOT_RUN" || run.testStatus == "INPROGRESS") {
                            self.testRunList.testRunList.append(run)
                        }
                    }
                        self.testList.reloadData()
                        
                        //Keep calling api while there are still more runs
                        if self.totalRunsReturnedFromServer < totalItems {
                            RestHelper.hitEndpoint(atEndpointString: self.buildTestRunEndpointString() + "&startAt=\(self.totalRunsReturnedFromServer)", withDelegate: self, username: self.username, password: self.password, timestamp: timestamp)
                            return
                        }
                    
                        //If there are no runs, display an empty run with the default value set to No Runs Found, made unclickable and with no number in the buildRunCell function below
                        if self.testRunList.testRunList.isEmpty && self.selectedTestCycleId != -1 {
                            let emptyRun = TestRunModel()
                            self.testRunList.testRunList.insert(emptyRun, at: 0)
                            self.testList.reloadData()
                        }
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
            
            selectedRunIndex = indexPath.row - selectedCycleTableViewIndex - 1
            runViewController.testRun = self.testRunList.testRunList[selectedRunIndex]
            runViewController.username = username
            runViewController.password = password
            runViewController.instance = instance
            runViewController.currentUser = currentUser
            runViewController.preserveCurrentRunStatus()
            runViewController.testRunDelegate = self
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
    
    func buildCell(indexPath: IndexPath) -> TestListTableViewCell {
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
            (testList.cellForRow(at: indexPath) as! TestListTableViewCell).unselectCell()
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
            selectedTestCycleId = -1
            testRunList.testRunList = []
            (testList.cellForRow(at: indexPath) as! TestListTableViewCell).unselectCell()
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
        
        //Slows down the user interaction slightly so that the table can keep up and not produce OOB
        testList.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.testList.isUserInteractionEnabled = true
        })
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
        
        //Slows down the user interaction slightly so that the table can keep up and not produce OOB
        testList.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.testList.isUserInteractionEnabled = true
        })
        //Empty out the previous test plan's cycle list and run list
        testCycleList.testCycleList = []
        testRunList.testRunList = []
        selectedPlanId = testPlanList.testPlanList[selectedPlanIndex].id
    }
    
    func buildTestRunCell(indexPath: IndexPath) -> TestListTableViewCell {
        let cell = TestListTableViewCell(style: .default, reuseIdentifier: "TestRunCell")
        let currentRunIndex = indexPath.row - selectedCycleTableViewIndex - 1
       
        cell.customInit(tableWidth: testList.frame.width, cellType: .testRun)
        if self.testRunList.testRunList[0].name == "No Runs Found" {
            cell.isUserInteractionEnabled = false
            cell.nameLabel.text = self.testRunList.testRunList[currentRunIndex].name
        } else {
            cell.nameLabel.text = "\(currentRunIndex + 1). " + self.testRunList.testRunList[currentRunIndex].name
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func buildTestCycleCell(indexPath: IndexPath) -> TestListTableViewCell {
        //Find the index into the testCycleList to get the cycle name for the current cell
        var currentCycleIndex = largeNumber
        if indexPath.row <= selectedCycleTableViewIndex {
            currentCycleIndex = indexPath.row - selectedPlanIndex - 1
        } else {
            currentCycleIndex = indexPath.row - selectedPlanIndex - testRunList.testRunList.count - 1
        }
        
        let cell = TestListTableViewCell(style: .default, reuseIdentifier: "TestCycleCell")
        cell.customInit(tableWidth: testList.frame.width, cellType: .testCycle)
        cell.nameLabel.text = self.testCycleList.testCycleList[currentCycleIndex].name
        
        //If cycle's cell is selected change the background color
        if selectedCycleTableViewIndex == indexPath.row {
            cell.selectCell()
        }

        if self.testCycleList.testCycleList[0].name == "No Cycles Found" {
            cell.isUserInteractionEnabled = false
            cell.icon.isHidden = true
        }
        return cell
    }
    
    func buildTestPlanCell(indexPath: IndexPath) -> TestListTableViewCell {
        let cell = TestListTableViewCell(style: .default, reuseIdentifier: "TestPlanCell")
        var currentPlanIndex = largeNumber
        
        cell.customInit(tableWidth: testList.frame.width, cellType: .testPlan)
       
        //Find the index into the testPlanList to get the plan name
        if indexPath.row <= selectedPlanIndex {
            currentPlanIndex = indexPath.row
        } else {
            currentPlanIndex = indexPath.row - testCycleList.testCycleList.count - testRunList.testRunList.count
        }
        cell.nameLabel.text = testPlanList.testPlanList[currentPlanIndex].name
        
        if selectedPlanIndex == indexPath.row {
            cell.selectCell()
        }
        return cell
    }
}

extension TestListViewController: TestRunDelegate {
    func didUpdateTestRun() {
        displayTestRunAlert = true
    }
    
    // Remove the run from the list unless the status is 'in progress'
    func removeUpdatedItemFromTable() {
        updatedRunName = testRunList.testRunList[selectedRunIndex].name
        self.didTapTestCycleCell(indexPath: IndexPath(row: selectedCycleTableViewIndex, section: 0))
        self.getRunsForCycleOnClick()
        
    }
}
