//
//  AddTaskViewController.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-03-19.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit
import Firebase

class AddTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var ref: DatabaseReference!

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var nameTextField: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var pointsTextField: UITextView!
    @IBOutlet weak var addedTasksTableView: UITableView!
    
    var placeOfHistoryCell = 0
    var taskList = TaskList(name: "Orvar")
    var listOfTaskLists = [TaskList]()
    var newTaskList = true
    var selectedRow = 0
    var currentList = "New list"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addedTasksTableView.dataSource = self
        addedTasksTableView.delegate = self
        print(placeOfHistoryCell)
        addedTasksTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    @IBAction func addTaskBtnPressed(_ sender: UIBarButtonItem) {
        popUpView.isHidden = false
    }
    
    @IBAction func doneBtnPressed(_ sender: UIButton) {
        ref = Database.database().reference()
        
        if newTaskList {
            taskList.addTask(Task(name: nameTextField.text, points: Int(pointsTextField.text)!))
            taskList.name = titleTextField.text!
            
            ref.child("New list").child(nameTextField.text).setValue(pointsTextField.text)
        }
        else {
            listOfTaskLists[selectedRow].addTask(Task(name: nameTextField.text, points: Int(pointsTextField.text)!))
            listOfTaskLists[selectedRow].name = titleTextField.text!
            
            ref.child(listOfTaskLists[selectedRow].name).child(nameTextField.text).setValue(pointsTextField.text)
            
        }
        popUpView.isHidden = true
        
        addedTasksTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newTaskList {
            return taskList.taskList.count
        }
        else {
            return listOfTaskLists[selectedRow].taskList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if newTaskList {
            cell?.textLabel?.text = taskList.taskList[indexPath.row].name
            cell?.detailTextLabel?.text = String(taskList.taskList[indexPath.row].points)
        }
        else {
            cell?.textLabel?.text = listOfTaskLists[selectedRow].taskList[indexPath.row].name
            cell?.detailTextLabel?.text = String(listOfTaskLists[selectedRow].taskList[indexPath.row].points)
        }
        
        return cell!
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tbc = segue.destination as? TabBarController
        
        if newTaskList {
            listOfTaskLists.append(taskList)
        }
        
        tbc?.listOfTaskLists = listOfTaskLists
        tbc?.placeOfHistoryCell = placeOfHistoryCell
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
