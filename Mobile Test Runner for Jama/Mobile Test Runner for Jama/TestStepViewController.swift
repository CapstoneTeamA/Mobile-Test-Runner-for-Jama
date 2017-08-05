//
//  TestStepViewController.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

class TestStepViewController: UIViewController {

    @IBOutlet weak var passButton: UIButton!
    @IBOutlet weak var failButton: UIButton!
    @IBOutlet weak var addResultsButton: UIButton!
    @IBOutlet weak var actionTextField: UITextView!
    @IBOutlet weak var expResultTextField: UITextView!
    @IBOutlet weak var notesTextField: UITextView!
    @IBOutlet weak var StepDetailTitle: UINavigationItem!
    
    var action = ""
    var expResult = ""
    var notes = ""
    var currentIndex = 0
    var indexLength = 0
    var indexDelegate: StepIndexDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionTextField.text = action
        expResultTextField.text = expResult
        notesTextField.text = notes
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
        //TODO handle the popup text box that the user will use to add results
    }
    
    @IBAction func didTapFail(_ sender: Any) {
        indexDelegate.didSetStatus(status: .fail)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapPass(_ sender: Any) {
        indexDelegate.didSetStatus(status: .pass)
        navigationController?.popViewController(animated: true)
    }
}
