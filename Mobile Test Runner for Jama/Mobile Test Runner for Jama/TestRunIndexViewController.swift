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
        return 20
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TestStepCell")
        
       // cell.textLabel?.text = "       \(indexPath.row + 1)   " + runName
        let nameLabel = UILabel(frame: CGRect(x: cell.bounds.minX, y: cell.bounds.minY, width: cell.contentView.bounds.width - 82, height: cell.contentView.bounds.height))
        
        nameLabel.center = CGPoint(x: nameLabel.bounds.width/2 + 45, y: cell.contentView.center.y)
        //I think this will need to be 2 labels so that they can all line up even when the number next to the name 
            //is more than single digits (the name of #9 and #10 are offset
        nameLabel.text = "\(indexPath.row + 1)     " +  runName + "aaaaaaaaaaaaaaaaaaaaaaa"
        let image = UIImage(named: "check_icon.png")
        let im = UIImageView(image: image)
        cell.contentView.addSubview(im)
        cell.contentView.addSubview(nameLabel)
        im.center = CGPoint(x: 24, y: 22)
        
        cell.accessoryType = .disclosureIndicator
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        
        return cell
    }
}
