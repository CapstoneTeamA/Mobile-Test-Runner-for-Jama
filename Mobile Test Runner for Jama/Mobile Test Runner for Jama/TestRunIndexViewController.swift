//
//  TestRunIndexViewController.swift
//  Mobile Test Runner for Jama
//
//  Created by Meghan McBee on 7/27/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

class TestRunIndexViewController: UIViewController, UITextViewDelegate {
   
    @IBOutlet weak var cancelRun: UIBarButtonItem!
    @IBOutlet weak var testRunNameLabel: UILabel!
    @IBOutlet weak var testStepTable: UITableView!
    @IBOutlet weak var inputResultsButton: UIButton!
    @IBOutlet weak var inputResultsBox: UIView!
    @IBOutlet weak var inputResultsTextBox: UITextView!
    @IBOutlet weak var inputResultsBackground: UIView!
    let screenSize = UIScreen.main.bounds
    
    var instance = ""
    var username = ""
    var password = ""
    var runId = -1
    var runName = ""
    var testRun: TestRunModel = TestRunModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide the default back button and instead show cancel run
        self.navigationItem.hidesBackButton = true
        testRunNameLabel.text = runName
        self.setupPopup()
        testStepTable.reloadData()
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
    
    // Used to set up text window popup, called in viewDidLoad
    func setupPopup() {
        NotificationCenter.default.addObserver(self, selector: #selector(TestRunIndexViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TestRunIndexViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        inputResultsBox.isHidden = true
        inputResultsBackground.isHidden = true
        inputResultsTextBox.delegate = self
    }
    
    // Called when 'Input Results' button is clicked
    @IBAction func enterText(_ sender: UIButton) {
        inputResultsBackground.isHidden = false
        inputResultsBox.isHidden = false
        self.inputResultsTextBox.delegate = self
    }
    
    // Called when 'Done' button in popup is clicked
    @IBAction func saveText(_ sender: UIButton) {
        inputResultsBackground.isHidden = true
        inputResultsBox.isHidden = true
        if testRun.result != inputResultsTextBox.text {
            testRun.result = inputResultsTextBox.text
        }
        inputResultsTextBox.resignFirstResponder()
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        inputResultsTextBox.resignFirstResponder()
        return (true)
    }
    
    // Resize popup when keyboard appears/hides
    func keyboardWillShow(notification: NSNotification) {
        let marginWidth = (screenSize.width/10)*9
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.inputResultsBox.frame = CGRect(x: (screenSize.width-marginWidth)/2, y: 75, width: marginWidth, height: (screenSize.height-75)-keyboardSize.height)
        }
        inputResultsBox.reloadInputViews()
    }
    func keyboardWillHide(notification: NSNotification) {
        let marginWidth = (screenSize.width/10)*9
        let yCoord = screenSize.midY/4
        self.inputResultsBox.frame = CGRect(x: (screenSize.width-marginWidth)/2, y: yCoord, width: marginWidth, height: (screenSize.height-75)/2)
        inputResultsBox.reloadInputViews()
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
        stepDetailController.action = "action"
        stepDetailController.expResult = "The purpose of this ticket is to enable the user to click on any of the test steps that are listed on the run view and navigate to a placeholder screen for that test step. For testing purposes, it is OK to implement a temporary back button on the destination screen so that you can navigate back to the test run list screen."
        
        stepDetailController.notes = "notes"
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
