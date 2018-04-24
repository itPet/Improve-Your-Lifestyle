//
//  CustomTableViewCell.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-04-16.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 5
        self.selectionStyle = .none
        
        self.contentView.backgroundColor = cellColor
        self.backgroundColor = cellColor
        nameLabel.textColor = normalTextColor
        pointsLabel.textColor = normalTextColor
        cellView.backgroundColor = taskBackgroundColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
