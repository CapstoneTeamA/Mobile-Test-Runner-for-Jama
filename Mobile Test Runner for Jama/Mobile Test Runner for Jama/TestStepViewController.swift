//
//  TestStepViewController.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

class TestStepViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var passButton: UIButton!
    @IBOutlet weak var failButton: UIButton!
    @IBOutlet weak var addResultsButton: UIButton!
    @IBOutlet weak var inputResultsBackground: UIView!
    @IBOutlet weak var inputResultsBox: UIView!
    @IBOutlet weak var inputResultsTextBox: UITextView!
    @IBOutlet weak var inputResultsButton: UIButton!
    @IBOutlet weak var StepDetailTitle: UINavigationItem!
    @IBOutlet weak var actionTextView: UITextView!
    @IBOutlet weak var expectedResultsTextView: UITextView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var actionTextViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var expectedResultsTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var notesTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var expectedResultButton: UIButton!
    @IBOutlet weak var notesButton: UIButton!
    @IBOutlet weak var runNameLabel: UILabel!
    @IBOutlet weak var runTitleLabel: UILabel!
    @IBOutlet weak var titleDivider: UIView!
    
    var action = ""
    var expResult = ""
    var notes = ""
    var stepResult = ""
    var runName = ""
    var currentIndex = 0
    var indexLength = 0
    var indexDelegate: StepIndexDelegate!
    let placeholderText = "Enter actual results here"
    let rightArrowStr = "small_right_chevron.png"
    let downArrowStr = "small_down_chevron.png"
    var titleAndDividerHeight: CGFloat = 0
    let textViewHeightRatio: CGFloat = 9/12 //Each of the 3 buttons are 1/12 the height of the superview
    let totalSpaceBetweenButtons: CGFloat = 6 //6 is 2px for each of the 3 buttons.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionTextView.text = action
        expectedResultsTextView.text = expResult
        notesTextView.text = notes
        self.setupPopup()
        self.title = "Step " + String(currentIndex+1) + "/" + String(indexLength);
        self.runNameLabel.text = runName
        
        //get the height of the title section to set the textviews' alignment
        titleAndDividerHeight = runNameLabel.frame.height + titleDivider.frame.height
        alignHeaderButtonContents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        expandActionTextView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapAddResult(_ sender: Any) {
        inputResultsBackground.isHidden = false
        inputResultsBox.isHidden = false
        self.navigationController?.view.addSubview(inputResultsBackground)
        self.navigationController?.view.addSubview(inputResultsBox)
    }
    
    @IBAction func didTapFail(_ sender: Any) {
        indexDelegate.didSetStatus(status: .fail)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapPass(_ sender: Any) {
        indexDelegate.didSetStatus(status: .pass)
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didTapActionHeader(_ sender: Any) {
        expandActionTextView()
    }
    
    @IBAction func didTapExpectedResultsHeader(_ sender: Any) {
        expandExpectedResultsTextView()
    }
    
    
    @IBAction func didTapNotesHeader(_ sender: Any) {
        expandNotesTextView()
    }
    
    func alignHeaderButtonContents() {
        let imageInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        let titleInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        //Set the insets for all the accordion buttons to layout the image and title of the button
        actionButton.imageEdgeInsets = imageInset
        actionButton.titleEdgeInsets = titleInset
        expectedResultButton.imageEdgeInsets = imageInset
        expectedResultButton.titleEdgeInsets = titleInset
        notesButton.imageEdgeInsets = imageInset
        notesButton.titleEdgeInsets = titleInset
    }
    
    func expandOrCollapseTextView(heightConstraint: NSLayoutConstraint, button: UIButton) {
        if heightConstraint.constant != 0 {
            heightConstraint.constant = 0
            button.setImage(UIImage.init(named: rightArrowStr), for: .normal)
        } else {
            //Make the text view as large as it can be while still fitting in its superview.
            heightConstraint.constant = (actionTextView.superview?.frame.height)! * textViewHeightRatio - titleAndDividerHeight - totalSpaceBetweenButtons
            button.setImage(UIImage.init(named: downArrowStr), for: .normal)
        }
    }
    
    func expandActionTextView() {
        //If the text view is showing collapse, otherwise expand in remaining space and set the button image to down arrow
//        if actionTextViewHeightContraint.constant != 0 {
//            actionTextViewHeightContraint.constant = 0
//            actionButton.setImage(UIImage.init(named: rightArrowStr), for: .normal)
//        } else {
//            //Make the text view as large as it can be while still fitting in its superview.
//            actionTextViewHeightContraint.constant = (actionTextView.superview?.frame.height)! * textViewHeightRatio - titleAndDividerHeight - totalSpaceBetweenButtons
//            actionButton.setImage(UIImage.init(named: downArrowStr), for: .normal)
//        }
        
        expandOrCollapseTextView(heightConstraint: actionTextViewHeightContraint, button: actionButton)
        //Set the other text views heights to 0
        expectedResultsTextViewHeightConstraint.constant = 0
        notesTextViewHeightConstraint.constant = 0
        //Set the other buttons images to right chevrons
        expectedResultButton.setImage(UIImage.init(named: rightArrowStr), for: .normal)
        notesButton.setImage(UIImage.init(named: rightArrowStr), for: .normal)
        //scroll the text view to the top
        actionTextView.scrollRectToVisible(CGRect.zero, animated: false)
    }
    
    func expandExpectedResultsTextView() {
        //If the text view is showing collapse, otherwise expand in remaining space and set the button image to down arrow
//        if expectedResultsTextViewHeightConstraint.constant != 0 {
//            expectedResultsTextViewHeightConstraint.constant = 0
//            expectedResultButton.setImage(UIImage.init(named: rightArrowStr), for: .normal)
//        } else {
//            //Make the text view as large as it can be while still fitting in its superview.
//            expectedResultsTextViewHeightConstraint.constant = (expectedResultsTextView.superview?.frame.height)! * textViewHeightRatio - titleAndDividerHeight - totalSpaceBetweenButtons
//            expectedResultButton.setImage(UIImage.init(named: downArrowStr), for: .normal)
//        }

        expandOrCollapseTextView(heightConstraint: expectedResultsTextViewHeightConstraint, button: expectedResultButton)
        //Set the other text views heights to 0
        actionTextViewHeightContraint.constant = 0
        notesTextViewHeightConstraint.constant = 0
        //Set the other buttons images to right chevrons
        actionButton.setImage(UIImage.init(named: rightArrowStr), for: .normal)
        notesButton.setImage(UIImage.init(named: rightArrowStr), for: .normal)
        //scroll the text view to the top
        expectedResultsTextView.scrollRectToVisible(CGRect.zero, animated: false)
    }
    
    func expandNotesTextView() {
        //If the text view is showing collapse, otherwise expand in remaining space and set the button image to down arrow
//        if notesTextViewHeightConstraint.constant != 0 {
//            notesTextViewHeightConstraint.constant = 0
//            notesButton.setImage(UIImage.init(named: rightArrowStr), for: .normal)
//        } else {
//            //Make the text view as large as it can be while still fitting in its superview.
//            notesTextViewHeightConstraint.constant = (notesTextView.superview?.frame.height)! * textViewHeightRatio - titleAndDividerHeight - totalSpaceBetweenButtons
//            notesButton.setImage(UIImage.init(named: downArrowStr), for: .normal)
//        }
        
        expandOrCollapseTextView(heightConstraint: notesTextViewHeightConstraint, button: notesButton)
        //Set the other text views heights to 0
        actionTextViewHeightContraint.constant = 0
        expectedResultsTextViewHeightConstraint.constant = 0
        //Set the other buttons images to right chevrons
        actionButton.setImage(UIImage.init(named: rightArrowStr), for: .normal)
        expectedResultButton.setImage(UIImage.init(named: rightArrowStr), for: .normal)
        //scroll the text view to the top
        notesTextView.scrollRectToVisible(CGRect.zero, animated: false)
    }
    
    
    // Used to set up text window popup, called in viewDidLoad
    func setupPopup() {
        NotificationCenter.default.addObserver(self, selector: #selector(TestStepViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TestStepViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        inputResultsBox.isHidden = true
        inputResultsBackground.isHidden = true
        inputResultsTextBox.delegate = self
        setPlaceholderText()
    }
    
    func setPlaceholderText() {
        if self.stepResult == "" {
            inputResultsTextBox.text = placeholderText
            inputResultsTextBox.textColor = UIColor(red: 0.5882, green: 0.5882, blue: 0.5882, alpha: 1.0) /* #969696 */
        } else {
            inputResultsTextBox.text = self.stepResult
        }
    }
    
    // Called when 'Done' button in popup is clicked
    @IBAction func saveText(_ sender: UIButton) {
        inputResultsBackground.isHidden = true
        inputResultsBox.isHidden = true
        if self.stepResult != inputResultsTextBox.text && inputResultsTextBox.text != placeholderText {
            self.stepResult = inputResultsTextBox.text
            indexDelegate.didSetResult(result: self.stepResult)
        }
        setPlaceholderText()
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
    
    @IBAction func didTapResetStep(_ sender: Any) {
        let clearAlert = UIAlertController(title: "Clear Step", message: "This step's status will be set to \"Not Run\" and the results will be cleared. Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        clearAlert.addAction(UIAlertAction(title: "Yes, I'm sure", style: .cancel, handler: {
            (action: UIAlertAction!) in
            //Reset the Result and Status fields for the step
            self.indexDelegate.didSetStatus(status: .not_run)
            self.indexDelegate.didSetResult(result: "")
            self.navigationController?.popViewController(animated: true)
        }))
        
        clearAlert.addAction(UIAlertAction(title: "Never mind", style: .default, handler: {
            (action: UIAlertAction) in
            _ = ""
        }))
        
        present(clearAlert, animated: true, completion: nil)
    }
    
}
