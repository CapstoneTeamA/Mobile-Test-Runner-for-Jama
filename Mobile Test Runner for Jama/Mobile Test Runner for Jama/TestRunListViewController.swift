//
//  TestRunListViewController.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

class TestRunListViewController: UIViewController {

    var projectName = ""
    var projectKey = ""
    @IBOutlet weak var tmpProjectLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tmpProjectLabel.text = projectName + "\nProject Key: " + projectKey
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
