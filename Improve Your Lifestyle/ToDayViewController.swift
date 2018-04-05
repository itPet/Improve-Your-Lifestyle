//
//  ToDayViewController.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-03-28.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit
import Firebase

class ToDayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    var userId = ""
    var placeOfHistoryCell = 0
    var subtract = 0
    @IBOutlet weak var toDayTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("toDayDidLoad")
        let tbc = tabBarController as! TabBarController
        placeOfHistoryCell = tbc.placeOfHistoryCell
        userId = tbc.userId
        toDayTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfTaskLists[0].taskList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDayCell", for: indexPath)
        let historyCell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        
        subtract = 0
        
        if indexPath.row > placeOfHistoryCell {
            subtract = 1
        }
        if indexPath.row == placeOfHistoryCell {
            historyCell.backgroundColor = UIColor.red
            historyCell.textLabel?.text = "Statistik"
            return historyCell
        }
        else {
            cell.textLabel?.text = listOfTaskLists[0].taskList[indexPath.row - subtract].name
            cell.detailTextLabel?.text = String(listOfTaskLists[0].taskList[indexPath.row - subtract].points)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row > placeOfHistoryCell {
            let elementToMove = listOfTaskLists[0].taskList[indexPath.row - subtract]

            if placeOfHistoryCell < listOfTaskLists[0].taskList.count {
                let tbc = tabBarController as! TabBarController
                placeOfHistoryCell += 1
                tbc.placeOfHistoryCell = placeOfHistoryCell
                ref = Database.database().reference()
                ref.child(userId).child("info").child("placeOfHistoryCell").setValue(String(placeOfHistoryCell))
            }
            
            listOfTaskLists[0].taskList.insert(elementToMove, at: placeOfHistoryCell - 1)
            listOfTaskLists[0].taskList.remove(at: (indexPath.row - subtract) + 1)
            toDayTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
