//
//  TestRunIndexViewController.swift
//  Mobile Test Runner for Jama
//
//  Created by Meghan McBee on 7/27/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

class TestRunIndexViewController: UIViewController {
    
    @IBOutlet weak var testStepTable: UITableView!
    var instance = ""
    var username = ""
    var password = ""
    var runId = -1
    var runName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testStepTable.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension TestRunIndexViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TestStepCell")
        
        cell.textLabel?.text = "       \(indexPath.row + 1)   " + runName
        cell.textLabel?.bounds = CGRect(x: 30, y: 3, width: cell.bounds.width - 40, height: cell.bounds.height - 6)
        let image = UIImage(named: "check_icon.png")
        let im = UIImageView(image: image)
        cell.contentView.addSubview(im)
        im.center = CGPoint(x: 24, y: 22)
        
        cell.accessoryType = .disclosureIndicator
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        
        return cell
    }
}
