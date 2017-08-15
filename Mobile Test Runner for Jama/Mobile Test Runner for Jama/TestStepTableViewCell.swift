//
//  TestStepTableViewCell.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 7/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

class TestStepTableViewCell: UITableViewCell {
    var statusIconImageView: UIImageView!
    var nameLabel: UILabel!
    var numberLabel: UILabel!
    
    var iconFileName = ""
    let iconOffset: CGFloat = 22
    let nameLabelOffset: CGFloat = 50
    let iconCenterX: CGFloat = 24
    let iconCenterY: CGFloat = 22
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //Configure the view for the selected state
    }

    func customInit(tableWidth: CGFloat, stepNumber: Int, stepName: String, stepStatus: String) {
        self.bounds = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: UIScreen.main.bounds.width, height: self.bounds.height)
        
        //Create the status image view from the images and set its position and inital display attribute
        var statusIcon: UIImage
        if stepStatus == "PASSED" {
            iconFileName = "check_icon_green.png"
            
        }
        else if stepStatus == "FAILED" {
            iconFileName = "X_icon_red.png"
        }
        else {
            iconFileName = "empty_icon_grey.png"
        }
        statusIcon = UIImage(named: iconFileName)!
        statusIconImageView = UIImageView(image: statusIcon)
        statusIconImageView.center = CGPoint(x: iconCenterX, y: iconCenterY)
        
        //Build the labels for the step number and step name
        numberLabel = UILabel(frame: CGRect(x: self.contentView.bounds.minX, y: self.contentView.bounds.minY, width: 40, height: self.contentView.bounds.height))
        nameLabel = UILabel(frame: CGRect(x: self.bounds.minX, y: self.bounds.minY, width: tableWidth - statusIconImageView.bounds.width - numberLabel.bounds.width - nameLabelOffset , height: self.contentView.bounds.height))
        
        //Set the position of the labels
        numberLabel.center = CGPoint(x: statusIconImageView.center.x + iconOffset + numberLabel.bounds.width/2 , y: self.contentView.center.y)
        nameLabel.center = CGPoint(x: numberLabel.center.x + iconOffset + nameLabel.bounds.width/2, y: self.contentView.center.y)
        
        numberLabel.text = "\(stepNumber)"
        nameLabel.text = stepName
        
        //Add all of the subviews to the content view of the cell
        self.contentView.addSubview(statusIconImageView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(numberLabel)
        
        //Set the accessory to the disclosureIndicator and make the cell dividors span the table width
        self.accessoryType = .disclosureIndicator
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
    }
}
