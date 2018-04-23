//
//  HomeTableViewCell.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-04-20.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit
import Firebase

class HomeTableViewCell: UITableViewCell{

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var privateLabel: UILabel!
    @IBOutlet weak var cellSwitch: UISwitch!
    
    var ref: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func switchMoved(_ sender: UISwitch) {
        var isActive = false
        if sender.isOn {
            isActive = true
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "saveIsActiveValue"), object: nil, userInfo: ["isActive": isActive, "tag": sender.tag])
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
