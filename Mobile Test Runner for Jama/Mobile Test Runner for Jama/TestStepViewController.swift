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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionTextField.text = action
        expResultTextField.text = expResult
        notesTextField.text = notes

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
