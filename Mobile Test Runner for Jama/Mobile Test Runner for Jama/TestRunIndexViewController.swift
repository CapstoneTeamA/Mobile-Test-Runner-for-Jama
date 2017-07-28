//
//  TestRunIndexViewController.swift
//  Mobile Test Runner for Jama
//
//  Created by Meghan McBee on 7/27/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

class TestRunIndexViewController: UIViewController {
    
    var instance = ""
    var username = ""
    var password = ""
    var runId = -1
    var runName = ""
    
    @IBOutlet weak var runNameLabel: UILabel!
    @IBOutlet weak var runIdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runNameLabel.text = "Name: " + runName
        runIdLabel.text = "Run ID: " + String(runId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
