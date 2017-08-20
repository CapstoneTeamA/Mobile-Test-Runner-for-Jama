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
    func didSetResult(result: String)
}

protocol RestPutDelegate {
    func didPutTestRun(responseCode: Int)
}

enum Status {
    case pass, fail, not_run
}

class TestRunIndexViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var blockButton: UIButton!
    @IBOutlet weak var cancelRun: UIBarButtonItem!
    @IBOutlet weak var testRunNameLabel: UILabel!
    @IBOutlet weak var testStepTable: UITableView!
    @IBOutlet weak var inputResultsButton: UIButton!
    @IBOutlet weak var inputResultsBox: UIView!
    @IBOutlet weak var inputResultsTextBox: UITextView!
    @IBOutlet weak var inputResultsBackground: UIView!
    @IBOutlet weak var noStepsView: UIView!
    @IBOutlet weak var noStepPassButton: UIButton!
    @IBOutlet weak var noStepFailButton: UIButton!
    @IBOutlet weak var noStepRunStatusLabel: UILabel!
    
    var instance = ""
    var username = ""
    var password = ""
    var runName = ""
    var currentlySelectedStepIndex = -1
    var testRun: TestRunModel = TestRunModel()
    var initialStepsStatusList: [String] = []
    var initialStepsResultsList: [String] = []
    var initialRunResultField = ""
    var currentUser: UserModel!
    var testRunDelegate: TestRunDelegate!
    var popupOriginY: CGFloat = 0
    let placeholderText = "Enter actual results here"
    let testRunStatusNotRunStr = "Test Run Status: Not Run"
    let testRunStatusInProgressStr = "Test Run Status: In Progress"
    let testRunStatusPassStr = "Test Run Status: Passed"
    let testRunStatusFailStr = "Test Run Status: Failed"
    let selectedPassButtonImage = UIImage.init(named: "PASS.png")
    let notSelectedPassButtonImage = UIImage.init(named: "PASS_UNSELECTED.png")
    let selectedFailButtonImage = UIImage.init(named: "FAIL.png")
    let notSelectedFailButtonImage = UIImage.init(named: "FAIL_UNSELECTED.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Hide the default back button and instead show cancel run
        self.navigationItem.hidesBackButton = true
        testRunNameLabel.text = testRun.name
        self.setupPopup()
        testStepTable.reloadData()
        noStepRunStatusLabel.text = testRunStatusInProgressStr
        noStepPassButton.setImage(notSelectedPassButtonImage, for: .normal)
        noStepFailButton.setImage(notSelectedFailButtonImage, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        testStepTable.reloadData()
        //If there are no steps, display the no steps view
        if testRun.testStepList.isEmpty {
            noStepsView.isHidden = false
        } else {
            noStepsView.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelRun(_ sender: UIBarButtonItem) {
        //If the cancel run button is hit, pop up an alert that either does nothing or goes back a screen to select a different run.
        let cancelAlert = UIAlertController(title: "Cancel Run", message: "All run data will be lost. Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        cancelAlert.addAction(UIAlertAction(title: "Yes, I'm sure", style: .cancel, handler: {
            (action: UIAlertAction!) in
            var index = 0
            //Run cancelled, reset all of the results and statuses to initial values
            for step in self.testRun.testStepList {
                step.status = self.initialStepsStatusList[index]
                step.result = self.initialStepsResultsList[index]
                index += 1
            }
            self.testRun.result = self.initialRunResultField
            self.navigationController?.popViewController(animated: true)
        }))
        
        cancelAlert.addAction(UIAlertAction(title: "Never mind", style: .default, handler: {
            (action: UIAlertAction!) in
            _ = ""
            
        }))
        
        present(cancelAlert, animated: true, completion: nil)
    }
    

    //If the submit run button is hit, pop up an alert that either does nothing or submits all of the run data to the API
    @IBAction func submitButton(_ sender: Any) {
        let submitAlert = UIAlertController(title: "Submit Run", message: "All run data will be saved and uploaded. Are you sure you want to submit?", preferredStyle: UIAlertControllerStyle.alert)
        
        submitAlert.addAction(UIAlertAction(title: "Yes, I'm sure", style: .cancel, handler: {
            (action: UIAlertAction!) in
            RestHelper.hitPutEndpoint(atEndpointString: self.buildTestRunPutEndpointString(), withDelegate: self, username: self.username, password: self.password, httpBodyData: self.buildPutRunBody())
        }))
        
        submitAlert.addAction(UIAlertAction(title: "Never mind", style: .default, handler: {
            (action: UIAlertAction!) in
            _ = ""
            
        }))
        
        present(submitAlert, animated: true, completion: nil)
    }
    
    //If the block run button is hit, pop up an alert that either does nothing or submits the run as blocked to the API
    @IBAction func blockedButton(_ sender: UIButton) {
        //Ensure that blocking will be allowed by the API
        if testRun.testStepList.isEmpty == false && testRun.testStepList.last?.status != "NOT_RUN" {
            let cannotBlockAlert = UIAlertController(title: "Cannot Block Run", message: "A run cannot be blocked if the last step has a status.", preferredStyle: .alert)
            cannotBlockAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                (action: UIAlertAction!) in
                _ = ""
            }))
            present(cannotBlockAlert, animated: true, completion: nil)
            return
        }
        //If the user is able to block the run, create confirmation alert
        let blockedAlert = UIAlertController(title: "Block Run", message: "This run will be marked as blocked. Are you sure you want to submit?", preferredStyle: UIAlertControllerStyle.alert)
        
        blockedAlert.addAction(UIAlertAction(title: "Yes, I'm sure", style: .cancel, handler: {
            (action: UIAlertAction!) in
            self.setupBlockedStatus()
            RestHelper.hitPutEndpoint(atEndpointString: self.buildTestRunPutEndpointString(),withDelegate: self, username: self.username, password: self.password, httpBodyData: self.buildPutRunBody())
        }))
        
        blockedAlert.addAction(UIAlertAction(title: "Never mind", style: .default, handler: {
            (action: UIAlertAction!) in
            _ = ""
            
        }))
        present(blockedAlert, animated: true, completion: nil)
    }
    
    func setupBlockedStatus() {
        if self.testRun.testStepList.isEmpty {
            self.testRun.testStatus = "BLOCKED"
        } else {
            //Go through the steps in reverse order and block until a step has a status
            for step in self.testRun.testStepList.reversed() {
                if step.status == "NOT_RUN" {
                    step.status = "BLOCKED"
                } else {
                    break
                }
            }
        }
    }
    
    //Save all of the inital values of the statuses and
    func preserveCurrentRunStatus() {
        for step in testRun.testStepList {
            let status = step.status
            let results = step.result
            initialStepsStatusList.append(status)
            initialStepsResultsList.append(results)
        }
        initialRunResultField = testRun.result
    }
    
    //Used to set up text window popup, called in viewDidLoad
    func setupPopup() {
        NotificationCenter.default.addObserver(self, selector: #selector(TestRunIndexViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TestRunIndexViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        inputResultsBox.isHidden = true
        inputResultsBackground.isHidden = true
        inputResultsTextBox.delegate = self
        setPlaceholderText()
    }
    
    func setPlaceholderText() {
        if testRun.result == "" {
            inputResultsTextBox.text = placeholderText
            inputResultsTextBox.textColor = UIColor(red: 0.5882, green: 0.5882, blue: 0.5882, alpha: 1.0) /* #969696 */
        } else {
            inputResultsTextBox.text = testRun.result
        }
    }
    
    //Called when 'Input Results' button is clicked
    @IBAction func enterText(_ sender: UIButton) {
        inputResultsBackground.isHidden = false
        inputResultsBox.isHidden = false
        popupOriginY = self.inputResultsBox.frame.origin.y
        self.navigationController?.view.addSubview(inputResultsBackground)
        self.navigationController?.view.addSubview(inputResultsBox)
    }
    
    //Called when 'Done' button in popup is clicked
    @IBAction func saveText(_ sender: UIButton) {
        inputResultsBackground.isHidden = true
        inputResultsBox.isHidden = true
        if testRun.result != inputResultsTextBox.text && inputResultsTextBox.text != placeholderText {
            testRun.result = inputResultsTextBox.text
        }
        setPlaceholderText()
        inputResultsTextBox.resignFirstResponder()
    }
    
    //Move popup when keyboard appears/hides
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if popupOriginY == self.inputResultsBox.frame.origin.y {
                self.inputResultsBox.frame.origin.y -= keyboardSize.height/3
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if popupOriginY != self.inputResultsBox.frame.origin.y {
            self.inputResultsBox.frame.origin.y = popupOriginY
        }
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        inputResultsTextBox.resignFirstResponder()
        return (true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if inputResultsTextBox.text == placeholderText {
            inputResultsTextBox.text = ""
            inputResultsTextBox.textColor = UIColor.black
        }
    }
    
    func togglePassButton() {
        //If the status label is the passing string then unselect the button and replace passing status with not run
        if noStepRunStatusLabel.text == testRunStatusPassStr {
            noStepRunStatusLabel.text = testRunStatusInProgressStr
            noStepPassButton.setImage(notSelectedPassButtonImage, for: .normal)
            testRun.testStatus = "INPROGRESS"
        } else {
            //Toggle pass button on, set test status and label and change pass button image to selected image
            noStepRunStatusLabel.text = testRunStatusPassStr
            noStepPassButton.setImage(selectedPassButtonImage, for: .normal)
            testRun.testStatus = "PASSED"
        }
        //Make sure the fail button image is the not selected image.
        noStepFailButton.setImage(notSelectedFailButtonImage, for: .normal)
    }
    
    func toggleFailButton() {
        //If the status label is the failing string then unselect the button and replace the failing status with in progress
        if noStepRunStatusLabel.text == testRunStatusFailStr {
            noStepRunStatusLabel.text = testRunStatusInProgressStr
            noStepFailButton.setImage(notSelectedFailButtonImage, for: .normal)
            testRun.testStatus = "INPROGRESS"
        } else {
            //Toggle fail button on, set test status and label and change the fail button image to selected image
            noStepRunStatusLabel.text = testRunStatusFailStr 
            noStepFailButton.setImage(selectedFailButtonImage, for: .normal)
            testRun.testStatus = "FAILED"
        }
        //Make sure the pass button image is the not selected image.
        noStepPassButton.setImage(notSelectedPassButtonImage, for: .normal)
    }
    
    //Button only visible when there are no steps in this run, allowing the user to pass the whole run.
    @IBAction func didTapPassRun(_ sender: Any) {
        togglePassButton()
    }
    
    //Button only visible when there are no steps in this run, allowing the user to fail the whole run
    @IBAction func didTapFailRun(_ sender: Any) {
        toggleFailButton()
    }

    //Build the endpoint for submitting the test run
    func buildTestRunPutEndpointString() -> String {
        var endpoint = RestHelper.getEndpointString(method: "Put", endpoint: "TestRuns")
        endpoint = "https://" + instance + "." + endpoint
        return endpoint.replacingOccurrences(of: "{id}", with: "\(testRun.id)")
    }
    
    func buildPutRunBody() -> Data {
        var stepList: [[String : AnyObject]] = []
        
        //Build the testRunSteps value for the API call
        for step in self.testRun.testStepList {
            let stepDict: [String : AnyObject] = [
                "action" : step.action as AnyObject,
                "expectedResult": step.expectedResult as AnyObject,
                "notes": step.notes as AnyObject,
                "result": step.result as AnyObject,
                "status": step.status as AnyObject
            ]
            stepList.append(stepDict)
        }
        
        var body: [String : AnyObject] = [:]
        //Add the needed values to update a test run
        body.updateValue(self.currentUser.id as AnyObject, forKey: "assignedTo")
        body.updateValue(self.testRun.result as AnyObject, forKey: "actualResults")
        
        //If there are no steps, submit a status. Otherwise submit the test steps
        //If the run has steps the status is a derived value based on the steps
        if self.testRun.testStepList.isEmpty {
            if self.testRun.testStatus == "NOT_RUN"{
                self.testRun.testStatus = "INPROGRESS"
            }
            body.updateValue(self.testRun.testStatus as AnyObject, forKey: "testRunStatus")
        } else {
            body.updateValue(stepList as AnyObject , forKey: "testRunSteps")
        }
        //Set the test run PUT values into a dictionary with "fields" as a key.
        let fields: [String : AnyObject] = ["fields" : body as AnyObject]
        if JSONSerialization.isValidJSONObject(body) {
            do {
                let data = try JSONSerialization.data(withJSONObject: fields)
                return data
            } catch {
                print("error")
            }
        }
        return Data()
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
        stepDetailController.stepResult = testRun.testStepList[indexPath.row].result
        
        stepDetailController.currentIndex = indexPath.row
        stepDetailController.indexLength = testRun.testStepList.count
        stepDetailController.runName = testRun.name
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
        case .not_run:
            result = "NOT_RUN"
        }
        testRun.testStepList[currentlySelectedStepIndex].status = result
    }
    
    func didSetResult(result: String) {
        testRun.testStepList[currentlySelectedStepIndex].result = result
    }
}

extension TestRunIndexViewController: RestPutDelegate {
    func didPutTestRun(responseCode: Int) {
        //If the update is successful, inform delegate and pop to the test list view
        if responseCode == 200 {
            self.testRunDelegate.didUpdateTestRun()
            DispatchQueue.main.async {
                self.testRunDelegate.removeUpdatedItemFromTable()
                self.navigationController?.popViewController(animated: true)
            }
           
        } else {
            //Create an alert to inform the user that the update failed
            let updateFailedAlert = UIAlertController(title: "Run not updated", message: "Attempt to update this run has failed. Try again.", preferredStyle: UIAlertControllerStyle.alert)
            updateFailedAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {
                (action: UIAlertAction!) in
                _ = ""
            }))
            DispatchQueue.main.async {
                self.present(updateFailedAlert, animated: true, completion: nil)
            }
        }
    }
}
