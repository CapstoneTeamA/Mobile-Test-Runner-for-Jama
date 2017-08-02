//
//  TestStepTableViewCell.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 7/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

class TestStepTableViewCell: UITableViewCell {
    var statusIconImageViewGreen: UIImageView!
    var statusIconImageViewGrey: UIImageView!
    var statusIconImageViewRed: UIImageView!

    let iconOffset: CGFloat = 22
    let nameLabelOffset: CGFloat = 50
    let iconCenterX: CGFloat = 24
    let iconCenterY: CGFloat = 22
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func customInit(tableWidth: CGFloat, stepNumber: Int, stepName: String, stepStatus: String) {
        self.bounds = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: UIScreen.main.bounds.width, height: self.bounds.height)
        
        //create the status image view from the images and set its position and inital display attribute
        let checkGreen = UIImage(named: "check_icon_green.png")
        statusIconImageViewGreen = UIImageView(image: checkGreen)
        statusIconImageViewGreen.center = CGPoint(x: iconCenterX, y: iconCenterY)
        statusIconImageViewGreen.isHidden = true
        let checkGrey = UIImage(named: "empty_icon_grey.png")
        statusIconImageViewGrey = UIImageView(image: checkGrey)
        statusIconImageViewGrey.center = CGPoint(x: iconCenterX, y: iconCenterY)
        statusIconImageViewGrey.isHidden = true
        let checkRed = UIImage(named: "X_icon_red.png")
        statusIconImageViewRed = UIImageView(image: checkRed)
        statusIconImageViewRed.center = CGPoint(x: iconCenterX, y: iconCenterY)
        statusIconImageViewRed.isHidden = true
        if stepStatus == "PASSED" {
            statusIconImageViewGreen.isHidden = false
            statusIconImageViewRed.isHidden = true
            statusIconImageViewGrey.isHidden = true
        }
        else if stepStatus == "FAILED" {
            statusIconImageViewRed.isHidden = false
            statusIconImageViewGrey.isHidden = true
            statusIconImageViewGreen.isHidden = true
        }
        else {
            statusIconImageViewGrey.isHidden = false
            statusIconImageViewGreen.isHidden = true
            statusIconImageViewRed.isHidden = true
        }
        
        //Build the labels for the step number and step name
        let numberLabel = UILabel(frame: CGRect(x: self.contentView.bounds.minX, y: self.contentView.bounds.minY, width: 40, height: self.contentView.bounds.height))
        let nameLabel = UILabel(frame: CGRect(x: self.bounds.minX, y: self.bounds.minY, width: tableWidth - statusIconImageViewGreen.bounds.width - numberLabel.bounds.width - nameLabelOffset , height: self.contentView.bounds.height))
        
        //set the position of the labels
        numberLabel.center = CGPoint(x: statusIconImageViewGreen.center.x + iconOffset + numberLabel.bounds.width/2 , y: self.contentView.center.y)
        nameLabel.center = CGPoint(x: numberLabel.center.x + iconOffset + nameLabel.bounds.width/2, y: self.contentView.center.y)
        
        numberLabel.text = "\(stepNumber)"
        nameLabel.text = stepName
        
        //Add all of the subviews to the content view of the cell
        self.contentView.addSubview(statusIconImageViewGreen)
        self.contentView.addSubview(statusIconImageViewGrey)
        self.contentView.addSubview(statusIconImageViewRed)

        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(numberLabel)
        
        //Set the accessory to the disclosureIndicator and make the cell dividors span the table width
        self.accessoryType = .disclosureIndicator
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
    }
}
