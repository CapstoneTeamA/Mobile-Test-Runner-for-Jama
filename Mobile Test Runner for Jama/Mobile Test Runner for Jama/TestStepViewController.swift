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
    
    var action = ""
    var expResult = ""
    var notes = ""
    var indexDelegate: StepIndexDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionTextField.text = action
        expResultTextField.text = expResult
        notesTextField.text = notes
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
    
    @IBAction func didTapResetStep(_ sender: Any) {
        let clearAlert = UIAlertController(title: "Clear Step", message: "This step's status will be set to \"Not Run\" and the results will be cleared. Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        clearAlert.addAction(UIAlertAction(title: "Yes, I'm sure", style: .default, handler: {
            (action: UIAlertAction!) in
            //TODO reset the Results field for the step
            self.indexDelegate.didSetStatus(status: .not_run)
            self.navigationController?.popViewController(animated: true)
        }))
        
        clearAlert.addAction(UIAlertAction(title: "Never mind", style: .cancel, handler: {
            (action: UIAlertAction) in
            _ = ""
        }))
        
        present(clearAlert, animated: true, completion: nil)
    }
    
}
