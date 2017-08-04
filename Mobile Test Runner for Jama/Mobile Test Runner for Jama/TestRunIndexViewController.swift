//
//  TestRunIndexViewController.swift
//  Mobile Test Runner for Jama
//
//  Created by Meghan McBee on 7/27/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

protocol StepIndexDelegate {
    func didSetStatus(status: Status)
}

enum Status {
    case pass, fail
}

class TestRunIndexViewController: UIViewController {
   
    @IBOutlet weak var cancelRun: UIBarButtonItem!
    @IBOutlet weak var testRunNameLabel: UILabel!
    @IBOutlet weak var testStepTable: UITableView!
    
    var instance = ""
    var username = ""
    var password = ""
    var runId = -1
    var runName = ""
    var currentlySelectedStepIndex = -1
    var testRun: TestRunModel = TestRunModel()
    var initialStepsStatusList: [String] = []
    var initialStepsResultsList: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide the default back button and instead show cancel run
        self.navigationItem.hidesBackButton = true
        testRunNameLabel.text = testRun.name
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        testStepTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelRun(_ sender: UIBarButtonItem) {
        //if the cancel run button is hit, pop up an alert that either does nothing or goes back a screen to select a different run.
        let cancelAlert = UIAlertController(title: "Cancel Run", message: "All run data will be lost. Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        cancelAlert.addAction(UIAlertAction(title: "Yes, I'm sure", style: .default, handler: {
            (action: UIAlertAction!) in
            var index = 0
            //Run cancelled, reset all of the results and statuses to initial values
            for step in self.testRun.testStepList {
                step.status = self.initialStepsStatusList[index]
                step.result = self.initialStepsResultsList[index]
                index += 1
            }
            self.navigationController?.popViewController(animated: true)
        }))
        
        cancelAlert.addAction(UIAlertAction(title: "Never mind", style: .cancel, handler: {
            (action: UIAlertAction!) in
            _ = ""
            
        }))
        
        present(cancelAlert, animated: true, completion: nil)
    }
    
    //Save all of the inital values of the statuses and
    func preserveCurrentRunStatus() {
        for step in testRun.testStepList {
            let status = step.status
            let results = step.result
            initialStepsStatusList.append(status)
            initialStepsResultsList.append(results)
        }
    }
}

extension TestRunIndexViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testRun.testStepList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = TestStepTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TestStepCell")
        cell.customInit(tableWidth: tableView.bounds.width, stepNumber: indexPath.row + 1, stepName: testRun.testStepList[indexPath.row].action, stepStatus: testRun.testStepList[indexPath.row].status)

        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stepDetailController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Test Step") as! TestStepViewController
        
        stepDetailController.action = testRun.testStepList[indexPath.row].action
        stepDetailController.expResult = testRun.testStepList[indexPath.row].expectedResult
        stepDetailController.notes = testRun.testStepList[indexPath.row].notes
        
        stepDetailController.currentIndex = indexPath.row
        stepDetailController.indexLength = testRun.testStepList.count
        
        currentlySelectedStepIndex = indexPath.row
        stepDetailController.indexDelegate = self
        self.navigationController?.pushViewController(stepDetailController, animated: true)
    }
}

extension TestRunIndexViewController: StepIndexDelegate {
    func didSetStatus(status: Status) {
        var result = ""
        switch status {
        case .fail:
            result = "FAILED"
        case .pass:
            result = "PASSED"
        }

        testRun.testStepList[currentlySelectedStepIndex].status = result

    }
}
