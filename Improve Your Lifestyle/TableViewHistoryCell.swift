//
//  TableViewHistoryCell.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-04-16.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit
import ChartProgressBar

class TableViewHistoryCell: UITableViewCell {

    @IBOutlet weak var chartProgressView: ChartProgressBar!
    @IBOutlet weak var viewOutsideChartProgressView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = tableViewBackgroundColor
        viewOutsideChartProgressView.backgroundColor = cellColor
        chartProgressView.backgroundColor = cellColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
