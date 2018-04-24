//
//  AddListTableViewCell.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-04-19.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit
import Firebase

class AddListTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        
        self.contentView.backgroundColor = cellColor
        self.backgroundColor = cellColor
        self.textLabel?.textColor = UIColor.lightGray
        textView.backgroundColor = cellColor
        textView.textColor = normalTextColor
        self.selectionStyle = .none
    }
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        var isPrivate = false
        if segmentedControl.selectedSegmentIndex == 0 {
            isPrivate = true
        }
        if !(sender.tag == -1) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "saveIsPrivateValue"), object: nil, userInfo: ["tag": sender.tag, "isPrivate": isPrivate])
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textView.isHidden = true
        segmentedControl.isHidden = true
        var isPrivate = false
        if segmentedControl.selectedSegmentIndex == 0 {
            isPrivate = true
        }

        NotificationCenter.default.post(name: Notification.Name(rawValue: "saveListValues"), object: nil, userInfo: ["title": textView.text!, "isPrivate" : isPrivate, "tag" : textField.tag])
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
