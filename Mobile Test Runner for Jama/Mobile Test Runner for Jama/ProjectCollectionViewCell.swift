//
//  ProjectCollectionViewCell.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 7/15/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

class ProjectCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var projectCellLabel: UILabel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.backgroundColor = UIColor(colorLiteralRed: 0xF5/0xFF, green: 0xF5/0xFF, blue: 0xF5/0xFF, alpha: 1)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.backgroundColor = UIColor.white
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.backgroundColor = UIColor.white
    }
}
