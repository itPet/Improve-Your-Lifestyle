//
//  HomeViewController.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-03-26.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ref: DatabaseReference!
    var listOfTaskLists = [TaskList]()
    var newTaskList = true
    var selectedRow = 0
    var placeOfHistoryCell = 0
    var currentList = "New list"
    
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbc = tabBarController as! TabBarController
        listOfTaskLists = tbc.listOfTaskLists
        placeOfHistoryCell = tbc.placeOfHistoryCell
        homeTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        var newList = [TaskList]()
        
        ref = Database.database().reference()
        ref.observe(.childAdded) { (snapshot) in
            
            newList.append(TaskList(name: snapshot.key))
            
            
            
            self.listOfTaskLists = newList
            self.homeTableView.reloadData()
        }
        
//        ref.child("Bra grejer").observe(.value) { (snapshot) in
//            print(snapshot.value as! [String: Int])
//        }
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
        
        addTaskViewController?.listOfTaskLists = listOfTaskLists
        addTaskViewController?.newTaskList = newTaskList
        addTaskViewController?.selectedRow = selectedRow
        addTaskViewController?.placeOfHistoryCell = placeOfHistoryCell
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
