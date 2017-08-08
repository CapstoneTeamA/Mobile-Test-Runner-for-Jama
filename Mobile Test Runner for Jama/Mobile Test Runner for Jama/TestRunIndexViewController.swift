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

enum Status {
    case pass, fail, not_run
}

class TestRunIndexViewController: UIViewController, UITextViewDelegate {
   
    @IBOutlet weak var cancelRun: UIBarButtonItem!
    @IBOutlet weak var testRunNameLabel: UILabel!
    @IBOutlet weak var testStepTable: UITableView!
    @IBOutlet weak var inputResultsButton: UIButton!
    @IBOutlet weak var inputResultsBox: UIView!
    @IBOutlet weak var inputResultsTextBox: UITextView!
    @IBOutlet weak var inputResultsBackground: UIView!
    @IBOutlet weak var noStepsView: UIView!
    @IBOutlet weak var noStepStatusIcon: UIImageView!
    
    var instance = ""
    var username = ""
    var password = ""
    var runName = ""
    var currentlySelectedStepIndex = -1
    var testRun: TestRunModel = TestRunModel()
    var initialStepsStatusList: [String] = []
    var initialStepsResultsList: [String] = []
    var initialRunResultField = ""
    let placeholderText = "Enter run results here"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide the default back button and instead show cancel run
        self.navigationItem.hidesBackButton = true
        testRunNameLabel.text = testRun.name
        self.setupPopup()
        testStepTable.reloadData()
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
            self.testRun.result = self.initialRunResultField
            self.navigationController?.popViewController(animated: true)
        }))
        
        cancelAlert.addAction(UIAlertAction(title: "Never mind", style: .cancel, handler: {
            (action: UIAlertAction!) in
            _ = ""
            
        }))
        
        present(cancelAlert, animated: true, completion: nil)
    }
    

    //if the submit run button is hit, pop up an alert that either does nothing or submits all of the run data to the API
    @IBAction func submitButton(_ sender: Any) {
        let submitAlert = UIAlertController(title: "Submit Run", message: "All run data will be saved and uploaded. Are you sure you want to submit?", preferredStyle: UIAlertControllerStyle.alert)
        
        submitAlert.addAction(UIAlertAction(title: "Yes, I'm sure", style: .default, handler: {
            (action: UIAlertAction!) in
            self.testRun.testStatus = "PASSED"
            for step in self.testRun.testStepList {
                if step.status == "FAILED" {
                    self.testRun.testStatus = "FAILED"
                    break
                }
                if step.status == "NOT_RUN" {
                    self.testRun.testStatus = "INPROGRESS"
                }
            }
            self.submitTestRun()
            self.navigationController?.popViewController(animated: true)
        }))
        
        submitAlert.addAction(UIAlertAction(title: "Never mind", style: .cancel, handler: {
            (action: UIAlertAction!) in
            _ = ""
            
        }))
        
        present(submitAlert, animated: true, completion: nil)
    }
    
    //if the block run button is hit, pop up an alert that either does nothing or submits the run as blocked to the API
    @IBAction func blockedButton(_ sender: UIButton) {
        let blockedAlert = UIAlertController(title: "Block Run", message: "This run will be marked as blocked. Are you sure you want to submit?", preferredStyle: UIAlertControllerStyle.alert)
        
        blockedAlert.addAction(UIAlertAction(title: "Yes, I'm sure", style: .default, handler: {
            (action: UIAlertAction!) in
            //TODO: add code to submit the run as blocked to the API
            for step in self.testRun.testStepList {
                if step.status == "NOT_RUN" {
                    step.status = "BLOCKED"
                }
            }
            
            self.submitTestRun()
            self.navigationController?.popViewController(animated: true)
        }))
        
        blockedAlert.addAction(UIAlertAction(title: "Never mind", style: .cancel, handler: {
            (action: UIAlertAction!) in
            _ = ""
            
        }))
        
        present(blockedAlert, animated: true, completion: nil)
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
    
    // Used to set up text window popup, called in viewDidLoad
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
    
    // Called when 'Input Results' button is clicked
    @IBAction func enterText(_ sender: UIButton) {
        inputResultsBackground.isHidden = false
        inputResultsBox.isHidden = false
    }
    
    // Called when 'Done' button in popup is clicked
    @IBAction func saveText(_ sender: UIButton) {
        inputResultsBackground.isHidden = true
        inputResultsBox.isHidden = true
        if testRun.result != inputResultsTextBox.text && inputResultsTextBox.text != placeholderText {
            testRun.result = inputResultsTextBox.text
        }
        inputResultsTextBox.resignFirstResponder()
    }
    
    // Move popup when keyboard appears/hides
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.inputResultsBox.frame.origin.y -= keyboardSize.height/3
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.inputResultsBox.frame.origin.y += keyboardSize.height/3
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
    @IBAction func didTapPassRun(_ sender: Any) {
        noStepStatusIcon.image = UIImage(named: "check_icon_green.png")
        testRun.testStatus = "PASSED"
    }
    
    @IBAction func didTapFailRun(_ sender: Any) {
        noStepStatusIcon.image = UIImage(named: "X_icon_red.png")
        testRun.testStatus = "FAILED"
    }

    
    //TODO make the link between the button and the setting of the status for the run
    //TODO make confirmation popup that this will submit the test run
    
    
    //build the endpoint for submitting the test run
    func buildTestRunEndpointString() -> String {
        var endpoint = RestHelper.getEndpointString(method: "Patch", endpoint: "TestRuns")
        endpoint = "https://" + instance + "." + endpoint
        return endpoint.replacingOccurrences(of: "{id}", with: "\(testRun.id)")
    }
    
    //build the JSON body of the put request
    func buildPATCHactualResults() -> Data {
        let dictionary: NSDictionary = [
            "op" : "add",
            "path" : "/fields/actualResults",
            "value" : self.testRun.result as NSString
        ]
        
        if JSONSerialization.isValidJSONObject(dictionary) {
            do{
                let data = try JSONSerialization.data(withJSONObject: dictionary)
                return data
            }catch {
                print("error")
            }
        }
        else {
            print("invalid JSON Object")
        }
        return Data()
    }
    
    //build the JSON body of the put request
    func buildPATCHTestSteps() -> Data {
        let stepList = NSMutableArray()
        for step in self.testRun.testStepList {
            let nsStep : NSDictionary = [
                "action": step.action as NSString,
                "expectedResult": step.expectedResult as NSString,
                "notes": step.notes as NSString,
                "result": step.result as NSString,
                "status": step.status as NSString
            ]
            stepList.add(nsStep)
        }
        
        let dictionary: NSDictionary = [
            "op" : "replace",
            "path" : "/fields/testRunSteps",
            "value" : stepList as NSArray
        ]
        
        if JSONSerialization.isValidJSONObject(dictionary) {
            do{
                let data = try JSONSerialization.data(withJSONObject: dictionary)
                return data
            }catch {
                print("error")
            }
        }
        else {
            print("invalid JSON Object")
        }
        return Data()
    }

    //build the JSON body of the put request
    func buildPATCHtestStatus() -> Data {
        let dictionary: NSDictionary = [
            "op" : "replace",
            "path" : "/fields/testRunStatus",
            "value" : self.testRun.testStatus as NSString
        ]
        
        if JSONSerialization.isValidJSONObject(dictionary) {
            do{
                let data = try JSONSerialization.data(withJSONObject: dictionary)
                return data
            }catch {
                print("error")
            }
        }
        else {
            print("invalid JSON Object")
        }
        return Data()
    }


    //make the put request with the test run data
   func submitTestRun() {
        let endpointStr = buildTestRunEndpointString()
        var request = RestHelper.prepareHttpRequest(atEndpointString: endpointStr, username: username, password: password, httpMethod: "PATCH")
    
        request?.httpMethod = "PATCH"
        request?.httpBody = buildPATCHTestSteps()

        let session = URLSession.shared
        var dataTask = session.dataTask(with: request!, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!) //grab this and display to the user
            }
        })
        dataTask.resume()
        sleep(1)
        request?.httpBody = buildPATCHactualResults()
    
        dataTask = session.dataTask(with: request!, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!) //grab this and display to the user
            }
        })
        dataTask.resume()
    
        if testRun.testStepList.isEmpty {
            sleep(1)
            request?.httpBody = buildPATCHtestStatus()
    
            dataTask = session.dataTask(with: request!, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error!)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse!) //grab this and display to the user
                }
            })
            dataTask.resume()
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
        stepDetailController.stepResult = testRun.testStepList[indexPath.row].result
        
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
        case .not_run:
            result = "NOT_RUN"
        }
        testRun.testStepList[currentlySelectedStepIndex].status = result
    }
    
    func didSetResult(result: String) {
        testRun.testStepList[currentlySelectedStepIndex].result = result
    }
}
