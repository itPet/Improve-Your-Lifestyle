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
    
    var userId = ""
    var placeOfHistoryCell = 0
    var taskList = TaskList(name: "Orvar")
    var newTaskList = true
    var selectedRow = 0
    var currentList = "New list"
    var dateToSave = ""
    var startDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addedTasksTableView.dataSource = self
        addedTasksTableView.delegate = self
        addedTasksTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    @IBAction func addTaskBtnPressed(_ sender: UIBarButtonItem) {
        popUpView.isHidden = false
    }
    
    @IBAction func doneBtnPressed(_ sender: UIButton) {
        if newTaskList {
            addInputToLocalTaskListAsNewList()
            addInputToFireBaseAsNewList()
        }
        else {
            addInputToLocalTaskList()
            addInputToFireBase()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.addedTasksTableView.endEditing(true)
    }
    
    func addInputToLocalTaskList () {
        listOfTaskLists[selectedRow].addTask(Task(name: nameTextField.text, points: Int(pointsTextField.text)!))
        listOfTaskLists[selectedRow].name = titleTextField.text!
    }
    
    func addInputToLocalTaskListAsNewList () {
        taskList.addTask(Task(name: nameTextField.text, points: Int(pointsTextField.text)!))
        taskList.name = titleTextField.text!
    }
    
    func addInputToFireBaseAsNewList () {
        ref = Database.database().reference()
        ref.child(userId).child("lists").child(String(listOfTaskLists.count)).child("listName").setValue(titleTextField.text!)
        ref.child(userId).child("lists").child(String(listOfTaskLists.count)).child("tasks").child(String(taskList.taskList.count - 1)).child("name").setValue(nameTextField.text!)
        ref.child(userId).child("lists").child(String(listOfTaskLists.count)).child("tasks").child(String(taskList.taskList.count - 1)).child("points").setValue(pointsTextField.text!)
        ref.child(userId).child("lists").child(String(listOfTaskLists.count)).child("tasks").child(String(taskList.taskList.count - 1)).child("completed").setValue("false")
    }
    
    func addInputToFireBase () {
        ref = Database.database().reference()
        ref.child(userId).child("lists").child(String(selectedRow)).child("listName").setValue(titleTextField.text!)
        ref.child(userId).child("lists").child(String(selectedRow)).child("tasks").child(String(listOfTaskLists[selectedRow].taskList.count - 1)).child("name").setValue(nameTextField.text!)
        ref.child(userId).child("lists").child(String(selectedRow)).child("tasks").child(String(listOfTaskLists[selectedRow].taskList.count - 1)).child("points").setValue(pointsTextField.text!)
        ref.child(userId).child("lists").child(String(selectedRow)).child("tasks").child(String(listOfTaskLists[selectedRow].taskList.count - 1)).child("completed").setValue("false")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tbc = segue.destination as? TabBarController
        
        if newTaskList {
            listOfTaskLists.append(taskList)
        }
        
        tbc?.placeOfHistoryCell = placeOfHistoryCell
        tbc?.dateToSave = dateToSave
        tbc?.startDate = startDate
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
