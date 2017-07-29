//
//  TestStepTableViewCell.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 7/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

class TestStepTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.accessoryType = .disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
