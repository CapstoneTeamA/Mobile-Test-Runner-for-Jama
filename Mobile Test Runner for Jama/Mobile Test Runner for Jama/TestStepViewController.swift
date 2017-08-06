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
    @IBOutlet weak var actionTextField: UITextView!
    @IBOutlet weak var expResultTextField: UITextView!
    @IBOutlet weak var notesTextField: UITextView!
    @IBOutlet weak var inputResultsBackground: UIView!
    @IBOutlet weak var inputResultsBox: UIView!
    @IBOutlet weak var inputResultsTextBox: UITextView!
    @IBOutlet weak var inputResultsButton: UIButton!
    @IBOutlet weak var StepDetailTitle: UINavigationItem!
    
    var action = ""
    var expResult = ""
    var notes = ""
    var stepResult = ""
    var currentIndex = 0
    var indexLength = 0
    var indexDelegate: StepIndexDelegate!
    let placeholderText = "Enter result notes here"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionTextField.text = action
        expResultTextField.text = expResult
        notesTextField.text = notes
        self.setupPopup()
        self.title = "Step " + String(currentIndex+1) + "/" + String(indexLength);
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //Needed to set all the textViews scrolled to the top when the view loads.
        actionTextField.scrollRangeToVisible(NSRange.init(location: 0, length: 0))
        expResultTextField.scrollRangeToVisible(NSRange.init(location: 0, length: 0))
        notesTextField.scrollRangeToVisible(NSRange.init(location: 0, length: 0))
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
    
}
