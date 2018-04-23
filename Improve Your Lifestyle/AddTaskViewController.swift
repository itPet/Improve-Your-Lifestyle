//
//  AddTaskViewController.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-03-19.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit
import Firebase

class AddTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref: DatabaseReference!

    @IBOutlet weak var pointsPickerView: UIPickerView!
    @IBOutlet weak var blurButton: UIButton!
    @IBOutlet var popUpView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addedTasksTableView: UITableView!
    @IBOutlet weak var theNavigationBar: UINavigationItem!
    
    var placeOfHistoryCell = 0
    var selectedRow = 0
    var selectedPickerValue = 5
    var shouldDeleteOrChange = false
    
    var rowToEdit = 0
    var currentList = "New list"
    var dateToSave = ""
    var startDate = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        addedTasksTableView.dataSource = self
        addedTasksTableView.delegate = self
        addedTasksTableView.tableFooterView = UIView(frame: CGRect.zero)
        popUpView.layer.cornerRadius = 5
        popUpView.layer.masksToBounds = true
        pointsPickerView.transform = CGAffineTransform(rotationAngle: (-90 * (.pi/180)))
        pointsPickerView.frame = CGRect(x: 0, y: 64, width: 263, height: 72)
    }
    
    // MARK: - PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        label.textAlignment = .center
        label.text = String(row + 1)
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = UIColor.white
        
        view.addSubview(label)
        view.transform = CGAffineTransform(rotationAngle: (90 * (.pi/180)))
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickerValue = row + 1
    }
    
    // MARK: - Buttons
    @IBAction func addTaskbtnPressed(_ sender: UIBarButtonItem) {
        animateIn()
    }
    
    @IBAction func blurBtnPressed(_ sender: UIButton) {
        animateOut()
    }
    
    func animateIn() {
        self.view.addSubview(popUpView)
        popUpView.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 100)
        popUpView.alpha = 0
        popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        pointsPickerView.selectRow(4, inComponent: 0, animated: false)
        selectedPickerValue = 5
        nameTextField.text = ""
        UIView.animate(withDuration: 0.4) {
            self.popUpView.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
            self.blurButton.alpha = 0.6
        }
        nameTextField.becomeFirstResponder()
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.4, animations: {
            self.popUpView.alpha = 0
            self.popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.blurButton.alpha = 0
        }) { (success:Bool) in
            self.popUpView.removeFromSuperview()
        }
        shouldDeleteOrChange = false
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
        if shouldDeleteOrChange {
            listOfTaskLists[selectedRow].taskList.remove(at: rowToEdit)
            
            ref = Database.database().reference()
            let lastTask = String(listOfTaskLists[selectedRow].taskList.count)
            ref.child(userId).child("lists").child(String(selectedRow)).child("tasks").child(lastTask).child("name").removeValue()
            ref.child(userId).child("lists").child(String(selectedRow)).child("tasks").child(lastTask).child("completed").removeValue()
            ref.child(userId).child("lists").child(String(selectedRow)).child("tasks").child(lastTask).child("points").removeValue()
            
            if listOfTaskLists[selectedRow].taskList.count > 0 {
                for i in rowToEdit...listOfTaskLists[selectedRow].taskList.count {
                    var a = i
                    if a == 0 {
                        a = 1
                    }
                    let name = listOfTaskLists[selectedRow].taskList[a - 1].name
                    let complete = String(listOfTaskLists[selectedRow].taskList[a - 1].completed)
                    let points = String(listOfTaskLists[selectedRow].taskList[a - 1].points)
                    ref.child(userId).child("lists").child(String(selectedRow)).child("tasks").child(String(a - 1)).child("name").setValue(name)
                    ref.child(userId).child("lists").child(String(selectedRow)).child("tasks").child(String(a - 1)).child("completed").setValue(complete)
                    ref.child(userId).child("lists").child(String(selectedRow)).child("tasks").child(String(a - 1)).child("points").setValue(points)
                }
            }
        }
        animateOut()
        addedTasksTableView.reloadData()
    }
    
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        ref = Database.database().reference()
        if shouldDeleteOrChange {
            listOfTaskLists[selectedRow].taskList[rowToEdit].name = nameTextField.text!
            listOfTaskLists[selectedRow].taskList[rowToEdit].points = selectedPickerValue
            
            ref.child(userId).child("lists").child(String(selectedRow)).child("tasks").child(String(rowToEdit)).child("name").setValue(nameTextField.text!)
            ref.child(userId).child("lists").child(String(selectedRow)).child("tasks").child(String(rowToEdit)).child("points").setValue(String(selectedPickerValue))
            
        } else {
            addInputToLocalTaskList()
            addInputToFireBase()
        }
        animateOut()
        addedTasksTableView.reloadData()
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfTaskLists[selectedRow].taskList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CustomTableViewCell", owner: self, options: nil)?.first as! CustomTableViewCell
        
        cell.nameLabel.text = listOfTaskLists[selectedRow].taskList[indexPath.row].name
        cell.pointsLabel.text = String(listOfTaskLists[selectedRow].taskList[indexPath.row].points)
        cell.cellView.layer.cornerRadius = 15
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shouldDeleteOrChange = true
        rowToEdit = indexPath.row
        animateIn()
        nameTextField.text = listOfTaskLists[selectedRow].taskList[indexPath.row].name
        pointsPickerView.selectRow(listOfTaskLists[selectedRow].taskList[indexPath.row].points - 1, inComponent: 0, animated: false)
        selectedPickerValue = listOfTaskLists[selectedRow].taskList[indexPath.row].points
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.addedTasksTableView.endEditing(true)
//    }
    
    func addInputToLocalTaskList () {
        listOfTaskLists[selectedRow].addTask(Task(name: nameTextField.text!, points: selectedPickerValue))
    }
    
    // MARK: - Firebase
    func addInputToFireBase () {
        ref = Database.database().reference()
        ref.child(userId).child("lists").child(String(selectedRow)).child("tasks").child(String(listOfTaskLists[selectedRow].taskList.count - 1)).child("name").setValue(nameTextField.text!)
        ref.child(userId).child("lists").child(String(selectedRow)).child("tasks").child(String(listOfTaskLists[selectedRow].taskList.count - 1)).child("points").setValue(String(selectedPickerValue))
        ref.child(userId).child("lists").child(String(selectedRow)).child("tasks").child(String(listOfTaskLists[selectedRow].taskList.count - 1)).child("completed").setValue("false")
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tbc = segue.destination as? TabBarController
        
        tbc?.placeOfHistoryCell = placeOfHistoryCell
        tbc?.dateToSave = dateToSave
        tbc?.startDate = startDate
    }
    
    // MARK: - Functions I don't use
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
