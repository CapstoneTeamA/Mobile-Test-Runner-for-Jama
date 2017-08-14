//
//  TestListTableViewCell.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 8/13/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

enum TestListCellType {
    case testPlan, testCycle, testRun
}

class TestListTableViewCell: UITableViewCell {
    var icon: UIImageView!
    var nameLabel: UILabel!
    var nameLabelOffset: CGFloat = 5
    var indentWidth: CGFloat = 10
    var acccessoryViewOffset: CGFloat = 30
//    let rightChevron = UIImage.init(named: "small_right_chevron.png")
    let downChevron = UIImage.init(named: "small_down_chevron.png")
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customInit(tableWidth: CGFloat, cellType: TestListCellType) {
        let image = downChevron
        icon = UIImageView(image: image)
        icon.isHidden = true
        switch cellType {
        case .testPlan:
            indentWidth = 0
            break
            
        case .testCycle:
            indentWidth = 20
            break
            
        case .testRun:
            indentWidth = 30
            break
        }
        
        icon.center = CGPoint(x: tableWidth - (image?.size.width)!/2 - 8, y: self.contentView.bounds.height/2)
        nameLabel = UILabel(frame: CGRect(x: self.bounds.minX, y: self.bounds.minY, width: tableWidth - nameLabelOffset - acccessoryViewOffset - indentWidth, height: self.contentView.bounds.height))
        nameLabel.center = CGPoint(x: indentWidth + nameLabelOffset + nameLabel.bounds.width/2, y: self.contentView.center.y)
        
        nameLabel.font = UIFont(name: "Helvetica Neue", size: 20.0)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(icon)
    }
    
    func selectCell() {
        icon.image = downChevron
        icon.isHidden = false
    }
    
    func unselectCell() {
        icon.isHidden = true
    }

}
