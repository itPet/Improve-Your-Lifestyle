//
//  HomeViewController.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-03-26.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit
import Firebase

var listOfTaskLists = [TaskList]()
var test  = true


class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userId = "playerId"
    var ref: DatabaseReference!
    var newTaskList = true
    var selectedRow = 0
    var placeOfHistoryCell = 0
    var currentList = "New list"
    
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbc = tabBarController as! TabBarController
        placeOfHistoryCell = tbc.placeOfHistoryCell
        userId = tbc.userId
        homeTableView.tableFooterView = UIView(frame: CGRect.zero)
        getDataFromFirebase()
        print("homeDidLoad")
    }
    
    func getDataFromFirebase() {
        var newList = [TaskList]()
        ref = Database.database().reference()
        ref.child(userId).child("lists").observeSingleEvent(of: .value) { (snapshot) in
            print("observed")
            var counter = 0
            for child in snapshot.children {
                let list = child as! DataSnapshot
                let dictionary = list.value as! [String: AnyObject]
                let listName = dictionary["listName"] as! String
                newList.append(TaskList(name: listName))
                
                for child in list.childSnapshot(forPath: "tasks").children {
                    let task = child as! DataSnapshot
                    let dictionary = task.value as! [String: AnyObject]
                    if let n = dictionary["name"] {
                        if let p = dictionary["points"] {
                            let name = n as! String
                            let points = p as! String
                            newList[counter].addTask(Task(name, Int(points)!))
                        }
                    }
                }
                counter += 1
            }
            listOfTaskLists = newList
            self.homeTableView.reloadData()
        }
        ref.child(userId).child("info").observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as? [String: AnyObject]
            if let p = dictionary?["placeOfHistoryCell"] {
                let placeOfHistoryCell = p as! String
                self.placeOfHistoryCell = Int(placeOfHistoryCell)!
                let tbc = self.tabBarController as! TabBarController
                tbc.placeOfHistoryCell = self.placeOfHistoryCell
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tbc = tabBarController as! TabBarController
        placeOfHistoryCell = tbc.placeOfHistoryCell
        homeTableView.reloadData()
        newTaskList = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfTaskLists.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)
        let lastCell = tableView.dequeueReusableCell(withIdentifier: "lastHomeCell", for: indexPath)
        
        if indexPath.row < listOfTaskLists.count {
            cell.textLabel?.text = listOfTaskLists[indexPath.row].name
            return cell
        }
        else {
            lastCell.textLabel?.text = "add list"
            lastCell.textLabel?.textColor = UIColor.gray
            return lastCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == (listOfTaskLists.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastHomeCell", for: indexPath) as! LastHomeTableViewCell
            
            cell.textField.isHidden = false
            print("false")
            homeTableView.reloadData()
            
        }
        else {
            newTaskList = false
            selectedRow = indexPath.row
            
            performSegue(withIdentifier: "toAddTask", sender: AnyObject.self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addTaskViewController = segue.destination as? AddTaskViewController
        
        addTaskViewController?.newTaskList = newTaskList
        addTaskViewController?.selectedRow = selectedRow
        addTaskViewController?.placeOfHistoryCell = placeOfHistoryCell
        addTaskViewController?.userId = userId
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
