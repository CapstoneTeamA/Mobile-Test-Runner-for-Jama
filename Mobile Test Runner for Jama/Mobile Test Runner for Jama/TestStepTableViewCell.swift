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
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func customInit(tableWidth: CGFloat, stepNumber: Int, stepName: String) {
        self.bounds = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: UIScreen.main.bounds.width, height: self.bounds.height)
        
        //create an image view from the image and set its position
        let image = UIImage(named: "check_icon.png")
        statusIconImageView = UIImageView(image: image)
        statusIconImageView.center = CGPoint(x: 24, y: 22)
        
        //Build the labels for the step number and step name
        let numberLabel = UILabel(frame: CGRect(x: self.contentView.bounds.minX, y: self.contentView.bounds.minY, width: 40, height: self.contentView.bounds.height))
        let nameLabel = UILabel(frame: CGRect(x: self.bounds.minX, y: self.bounds.minY, width: tableWidth - statusIconImageView.bounds.width - numberLabel.bounds.width - 50 , height: self.contentView.bounds.height))
        
        //set the position of the labels
        numberLabel.center = CGPoint(x: statusIconImageView.center.x + 22 + numberLabel.bounds.width/2 , y: self.contentView.center.y)
        nameLabel.center = CGPoint(x: numberLabel.center.x + 22 + nameLabel.bounds.width/2, y: self.contentView.center.y)
        
        numberLabel.text = "\(stepNumber)"
        //added a long string at the end to show proof of concept that the name truncates correctly
        nameLabel.text = stepName + "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        
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
