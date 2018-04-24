//
//  DownloadTableViewCell.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-04-22.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit
import Firebase

class DownloadTableViewCell: UITableViewCell {

    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var downloadIcon: UIImageView!
    
    var ref: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        downloadLabel.textColor = normalTextColor
        self.contentView.backgroundColor = cellColor
        //self.backgroundColor = cellColor
        self.textLabel?.textColor = normalTextColor

        //self.selectionStyle = .none
    }
    @IBAction func downloadIconPressed(_ sender: UITapGestureRecognizer) {
        listOfTaskLists.append(publicLists[downloadIcon.tag])
        downloadedRows.append(downloadIcon.tag)
        addListToFirebase()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateTableView"), object: nil)
    }
    
    func addListToFirebase() {
        ref = Database.database().reference()
        let refToList = ref.child(userId).child("lists").child(String(listOfTaskLists.count-1))
        refToList.child("isActive").setValue("false")
                refToList.child("isPrivate").setValue("true")
                refToList.child("listName").setValue(publicLists[downloadIcon.tag].name)
        
                if publicLists[downloadIcon.tag].taskList.count > 0 {
                    for i in 0...publicLists[downloadIcon.tag].taskList.count - 1 {
                        let refToTasks = refToList.child("tasks")
                        refToTasks.child(String(i)).child("completed").setValue("false")
                        refToTasks.child(String(i)).child("name").setValue(publicLists[downloadIcon.tag].taskList[i].name)
                        refToTasks.child(String(i)).child("points").setValue(String(publicLists[downloadIcon.tag].taskList[i].points))
                    }
                }
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
