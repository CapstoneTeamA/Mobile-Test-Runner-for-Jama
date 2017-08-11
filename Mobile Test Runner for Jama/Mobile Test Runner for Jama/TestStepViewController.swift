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
    
    var action = ""
    var expResult = ""
    var notes = ""
    var stepResult = ""
    var currentIndex = 0
    var indexLength = 0
    var indexDelegate: StepIndexDelegate!
    let placeholderText = "Enter result notes here"
    let rightArrowImage = UIImage.init(named: "right_chevron.png")
    let downArrowImage = UIImage.init(named: "down_chevron.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionTextView.text = action
        expectedResultsTextView.text = expResult
        notesTextView.text = notes
        self.setupPopup()
        self.title = "Step " + String(currentIndex+1) + "/" + String(indexLength);
        
        actionTextView.scrollRangeToVisible(NSRange.init(location: 0, length: 0))
        expectedResultsTextView.scrollRangeToVisible(NSRange.init(location: 0, length: 0))
        notesTextView.scrollRangeToVisible(NSRange.init(location: 0, length: 0))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //Needed to set all the textViews scrolled to the top when the view loads.

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
    
    func expandActionTextView() {
        if actionTextViewHeightContraint.constant != 0 {
            actionTextViewHeightContraint.constant = 0
            actionButton.setImage(UIImage.init(named: "right_chevron.png"), for: .normal)
        } else {
            actionTextViewHeightContraint.constant = (actionTextView.superview?.frame.height)! * 9 / 12 - 6
            actionButton.setImage(UIImage.init(named: "down_chevron.png"), for: .normal)
           // actionButton.imageView?.image = UIImage.init(named: "down_chevron.png")
        }
        expectedResultsTextViewHeightConstraint.constant = 0
        notesTextViewHeightConstraint.constant = 0
        expectedResultButton.setImage(UIImage.init(named: "right_chevron.png"), for: .normal)
        notesButton.setImage(UIImage.init(named: "right_chevron.png"), for: .normal)
    }
    
    func expandExpectedResultsTextView() {
        if expectedResultsTextViewHeightConstraint.constant != 0 {
            expectedResultsTextViewHeightConstraint.constant = 0
            expectedResultButton.setImage(UIImage.init(named: "right_chevron.png"), for: .normal)
        } else {
            expectedResultsTextViewHeightConstraint.constant = (expectedResultsTextView.superview?.frame.height)! * 9 / 12 - 6
            expectedResultButton.setImage(UIImage.init(named: "down_chevron.png"), for: .normal)
            //expectedResultButton.imageView?.image = UIImage.init(named: "down_chevron.png")
        }
        actionTextViewHeightContraint.constant = 0
        notesTextViewHeightConstraint.constant = 0
        actionButton.setImage(UIImage.init(named: "right_chevron.png"), for: .normal)
        //actionButton.imageView?.image = UIImage.init(named: "right_chevron.png")
        notesButton.setImage(UIImage.init(named: "right_chevron.png"), for: .normal)
        //notesButton.imageView?.image = UIImage.init(named: "right_chevron.png")
        
    }
    
    func expandNotesTextView() {
        if notesTextViewHeightConstraint.constant != 0 {
            notesTextViewHeightConstraint.constant = 0
            notesButton.setImage(UIImage.init(named: "right_chevron.png"), for: .normal)
        } else {
            notesTextViewHeightConstraint.constant = (notesTextView.superview?.frame.height)! * 9 / 12 - 6
            notesButton.setImage(UIImage.init(named: "down_chevron.png"), for: .normal)
        }
        actionTextViewHeightContraint.constant = 0
        expectedResultsTextViewHeightConstraint.constant = 0
        actionButton.setImage(UIImage.init(named: "right_chevron.png"), for: .normal)
        expectedResultButton.setImage(UIImage.init(named: "right_chevron.png"), for: .normal)
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
        if self.stepResult != inputResultsTextBox.text && self.stepResult != placeholderText {
            self.stepResult = inputResultsTextBox.text
            indexDelegate.didSetResult(result: self.stepResult)
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
    
    @IBAction func didTapResetStep(_ sender: Any) {
        let clearAlert = UIAlertController(title: "Clear Step", message: "This step's status will be set to \"Not Run\" and the results will be cleared. Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        clearAlert.addAction(UIAlertAction(title: "Yes, I'm sure", style: .default, handler: {
            (action: UIAlertAction!) in
            //Reset the Result and Status fields for the step
            self.indexDelegate.didSetStatus(status: .not_run)
            self.indexDelegate.didSetResult(result: "")
            self.navigationController?.popViewController(animated: true)
        }))
        
        clearAlert.addAction(UIAlertAction(title: "Never mind", style: .cancel, handler: {
            (action: UIAlertAction) in
            _ = ""
        }))
        
        present(clearAlert, animated: true, completion: nil)
    }
    
}
