//
//  LastHomeTableViewCell.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-04-03.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit

class LastHomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    @IBAction func textFieldAction(_ sender: UITextField) {
        print("action")
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
