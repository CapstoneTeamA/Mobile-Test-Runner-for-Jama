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

protocol AttachmentApiEndpointDelegate {
    func didCreateEmptyAttachment(withId: Int)
    func didAddPhotoToAttachment()
    func didConnectRunAndAttachment(attachmentWarning: AttachmentWarning)
}

enum Status {
    case pass, fail, not_run
}

enum AttachmentWarning {
    case widgetWarning, imageUploadWarning, none
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
    @IBOutlet weak var currentAttachedImageView: UIView!
    @IBOutlet weak var currentAttachedImage: UIImageView!
    @IBOutlet weak var closeImageViewButton: UIButton!
    
    var instance = ""
    var username = ""
    var password = ""
    var runName = ""
    var projectId = -1
    var currentlySelectedStepIndex = -1
    var attachmentId = -1
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
    var photoToAttach: UIImage?
    let noAttachmentImage = UIImage.init(named: "nophotos-v1.png")
    let closeCurrentImageViewButtonBorderWidth: CGFloat = 1
    let closeCurrentImageViewButtonCornerRadius: CGFloat = 5
    let orangeColor = UIColor(red: 0xF1/0xFF, green: 0x61/0xFF, blue: 0x2A/0xFF, alpha: 1)
    let lightGrayColor = UIColor(red: 0xE6/0xFF, green: 0xE6/0xFF, blue: 0xE6/0xFF, alpha: 1)
    let translucentWhiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
    
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
        photoToAttach = nil
        //Setup the close current image view button
        closeImageViewButton.setTitleColor(orangeColor, for: .normal)
        closeImageViewButton.layer.borderColor = lightGrayColor.cgColor
        closeImageViewButton.layer.borderWidth = closeCurrentImageViewButtonBorderWidth
        closeImageViewButton.layer.cornerRadius = closeCurrentImageViewButtonCornerRadius
        closeImageViewButton.layer.backgroundColor = translucentWhiteColor.cgColor
        currentAttachedImageView.isHidden = true
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
            if self.photoToAttach != nil {
                RestHelper.createNewAttachmentItem(atEndpointString: self.buildEmptyAttachmentEndpointString(), withDelegate: self, username: self.username, password: self.password, runName: self.testRun.name)
            } else {
                RestHelper.hitPutEndpoint(atEndpointString: self.buildTestRunPutEndpointString(), withDelegate: self, username: self.username, password: self.password, httpBodyData: self.buildPutRunBody())
            }
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
            if self.photoToAttach != nil {
                RestHelper.createNewAttachmentItem(atEndpointString: self.buildEmptyAttachmentEndpointString(), withDelegate: self, username: self.username, password: self.password, runName: self.testRun.name)
            } else {
                RestHelper.hitPutEndpoint(atEndpointString: self.buildTestRunPutEndpointString(), withDelegate: self, username: self.username, password: self.password, httpBodyData: self.buildPutRunBody())
            }
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
        self.cancelRun.isEnabled = false
    }
    
    //Called when 'Done' button in popup is clicked
    @IBAction func saveText(_ sender: UIButton) {
        inputResultsBackground.isHidden = true
        inputResultsBox.isHidden = true
        if testRun.result != inputResultsTextBox.text && inputResultsTextBox.text != placeholderText {
            testRun.result = inputResultsTextBox.text
        }
        setPlaceholderText()
        self.cancelRun.isEnabled = true
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        inputResultsTextBox.resignFirstResponder()
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
    
    @IBAction func closeAttachedImageView(_ sender: Any) {
        self.currentAttachedImageView.isHidden = true
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

extension TestRunIndexViewController: AttachmentApiEndpointDelegate {
    //Building endpoint to create the new "empty" attachment
    func buildEmptyAttachmentEndpointString() -> String {
        var endpoint = RestHelper.getEndpointString(method: "Post", endpoint: "EmptyAttachment")
        endpoint = "https://" + instance + "." + endpoint
        endpoint = endpoint.replacingOccurrences(of: "{projectId}", with: "\(projectId)")
        return endpoint
    }
    
    //Building endpoint to upload the image to the newly created attachment
    func buildAttachmentFileEndpointString(attachmentId: Int) -> String {
        var endpoint = RestHelper.getEndpointString(method: "Put", endpoint: "AttachmentFile")
        endpoint = "https://" + instance + "." + endpoint
        endpoint = endpoint.replacingOccurrences(of: "{attachmentId}", with: "\(attachmentId)")
        return endpoint
    }
    
    //Building endpoint to connect the submitted test run to the newly created attachment with the image.
    func buildConnectRunAndAttachmentEndpointString() -> String {
        var endpoint = RestHelper.getEndpointString(method: "Post", endpoint: "TestRunAttachment")
        endpoint = "https://" + instance + "." + endpoint
        endpoint = endpoint.replacingOccurrences(of: "{testRunId}", with: "\(testRun.id)")
        return endpoint
    }
    
    //Once the API returns with the newly created "empty" attachment, call the upload image endpoint with the attachment id.
    func didCreateEmptyAttachment(withId: Int) {
        attachmentId = withId
        let endpoint = buildAttachmentFileEndpointString(attachmentId: withId)
        RestHelper.putImageToAttachmentFile(atEndpointString: endpoint, image: photoToAttach!, withDelegate: self, username: username, password: password, runName: testRun.name)
    }
    
    //Once the API returns from the image upload, call to connect the attachment to the test run
    func didAddPhotoToAttachment() {
        let endpoint = buildConnectRunAndAttachmentEndpointString()
        RestHelper.associateAttachmentToRun(atEndpointString: endpoint, withDelegate: self, username: username, password: password, attachmentId: attachmentId)
    }
    
    func didConnectRunAndAttachment(attachmentWarning: AttachmentWarning) {
        //If the API returns the error message, determine the warning to use to inform the user.
        if attachmentWarning != .none {
            var message = ""
            if attachmentWarning == .widgetWarning {
                //In order to upload attachments the attachment widget must be enabled on test runs.
                message = "Attachment widget not enabled for test runs. Test run will still be submitted. Please contact your administrator."
            } else if attachmentWarning == .imageUploadWarning {
                //Not sure why this happens but it consistently happens for certain test runs.
                message = "Attachment image could not be uploaded. Test run will still be submitted."
            }
            //Inform the user of the error via popup, then submit the test run.
            let attachmentFailedAlert = UIAlertController(title: "Attachment failed", message: message, preferredStyle: UIAlertControllerStyle.alert)
            attachmentFailedAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {
                (action: UIAlertAction!) in
                RestHelper.hitPutEndpoint(atEndpointString: self.buildTestRunPutEndpointString(), withDelegate: self, username: self.username, password: self.password, httpBodyData: self.buildPutRunBody())
            }))
            DispatchQueue.main.async {
                self.present(attachmentFailedAlert, animated: true, completion: nil)
            }
        } else {
            //No error, call to submit the test run.
            RestHelper.hitPutEndpoint(atEndpointString: buildTestRunPutEndpointString(), withDelegate: self, username: username, password: password, httpBodyData: buildPutRunBody())
        }
    }
}

extension TestRunIndexViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Call action sheet where user can take new photo, view current photo or delete photo
    @IBAction func photoButton(_ sender: Any) {
        //If the user does not have a Named type license then they cannot create attachments. Inform the user.
        if currentUser.licenseType != "NAMED" {
            let licenseErrorAlert = UIAlertController(title: "License error", message: "In order to upload attachments, the user must have a license of type \"Named\". Please contact your administrator.", preferredStyle: UIAlertControllerStyle.alert)
            licenseErrorAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {
                (action: UIAlertAction!) in
            }))
            DispatchQueue.main.async {
                self.present(licenseErrorAlert, animated: true, completion: nil)
            }
            return
        }
        let photoOptions = UIAlertController(title: nil, message: "Add, retake, or remove a photo", preferredStyle: .actionSheet)
            
        let useCamera = UIAlertAction(title: "Take Photo", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.takePhoto()
        })
        
        let viewPhoto = UIAlertAction(title: "View Image", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.showCurrentImageView()
        })
            
        let removePhoto = UIAlertAction(title: "Remove This Image", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.removeCurrentAttachmentImage()
        })
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
        photoOptions.addAction(useCamera)
        photoOptions.addAction(viewPhoto)
        photoOptions.addAction(removePhoto)
        photoOptions.addAction(cancelAction)
        self.present(photoOptions, animated: true, completion: nil)
    }
    
    //User selected take new photo, show camera
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //User selected show current photo, set the image for currentAttachedImageView and unhide it
    func showCurrentImageView() {
        if self.photoToAttach != nil{
            self.currentAttachedImage.image = self.photoToAttach
        } else {
            self.currentAttachedImage.image = self.noAttachmentImage
        }
        self.currentAttachedImageView.isHidden = false
    }
    
    //User selected remove current image, set the currentAttachedImage to the no attachment image and set the photoToAttach to nil
    func removeCurrentAttachmentImage() {
        self.photoToAttach = nil
        self.currentAttachedImage.image = self.noAttachmentImage
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.photoToAttach = pickedImage
            self.currentAttachedImage.image = self.photoToAttach
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
