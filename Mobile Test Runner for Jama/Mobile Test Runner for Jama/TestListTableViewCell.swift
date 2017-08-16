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
    var indentWidth: CGFloat = 10
    var acccessoryViewOffset: CGFloat = 35
    var fontSize: CGFloat = 20
    let rightChevron = UIImage.init(named: "small_right_chevron.png")
    let downChevron = UIImage.init(named: "small_down_chevron.png")
    let planIndentLevel: CGFloat = 12
    let cycleIndentLevel: CGFloat = 28
    let runIndentLevel: CGFloat = 28
    let nameLabelLeftPadding: CGFloat = 6
    let planBackgroundColor = UIColor.init(red: 0xE6/0xFF, green: 0xE6/0xFF, blue: 0xE6/0xFF, alpha: 1)
    let cycleBackgroundColor = UIColor.init(red: 0xF5/0xFF, green: 0xF5/0xFF, blue: 0xF5/0xFF, alpha: 1)
    let runBackgroundColor = UIColor.white
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func customInit(tableWidth: CGFloat, cellType: TestListCellType) {
        let image = rightChevron
        icon = UIImageView(image: image)
        switch cellType {
        case .testPlan:
            indentWidth = planIndentLevel
            backgroundColor = planBackgroundColor
            break
            
        case .testCycle:
            indentWidth = cycleIndentLevel
            fontSize = 18
            backgroundColor = cycleBackgroundColor
            break
            
        case .testRun:
            icon.isHidden = true
            indentWidth = runIndentLevel
            fontSize = 17
            backgroundColor = runBackgroundColor
            break
        }
        
        icon.center = CGPoint(x: icon.bounds.width/2 + indentWidth, y: self.contentView.bounds.height/2)
        nameLabel = UILabel(frame: CGRect(x: self.bounds.minX, y: self.bounds.minY, width: tableWidth - icon.bounds.width - acccessoryViewOffset - indentWidth, height: self.contentView.bounds.height))
        nameLabel.center = CGPoint(x: indentWidth + icon.bounds.width + nameLabelLeftPadding + nameLabel.bounds.width/2, y: self.contentView.center.y)
        nameLabel.font = UIFont(name: "Helvetica Neue", size: fontSize)
        nameLabel.textAlignment = .left
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(icon)
    }
    
    func selectCell() {
        icon.image = downChevron
    }
    
    func unselectCell() {
        icon.image = rightChevron
    }

}
