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
var listOfHistory = [OneDaysHistory]()
var userId = ""

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ref: DatabaseReference!
    var currentList = "New list"
    var dateToSave = ""
    var lastCellClicked = false
    var editMode = false
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    // MARK: - Starter functions
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func setColors() {
        view.backgroundColor = UIColor.black
        homeTableView.backgroundColor = tableViewBackgroundColor
        navigationBar.backgroundColor = headerAndFooterColor
        editButton.tintColor = tabBarButtonColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColors()
        
        
        if let id = UserDefaults.standard.object(forKey: "userId") as? String {
            userId = id
        } else {
            saveUserId()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveListValues(_:)), name: Notification.Name(rawValue: "saveListValues"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveIsPrivateValue(_:)), name: Notification.Name(rawValue: "saveIsPrivateValue"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveIsActiveValue(_:)), name: Notification.Name(rawValue: "saveIsActiveValue"), object: nil)
        
        let tbc = tabBarController as! TabBarController
        dateToSave = tbc.dateToSave
        
        homeTableView.tableFooterView = UIView(frame: CGRect.zero)
        getDataFromFirebase()
        homeTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        homeTableView.reloadData()
    }
    
    func saveUserId() {
        ref = Database.database().reference()
        userId = ref.childByAutoId().key
        let defaults = UserDefaults.standard
        defaults.set(userId, forKey: "userId")
        defaults.synchronize()
    }
    
    // MARK: - Firebase
    func getDataFromFirebase() {
        getListsFromFirebase()
        getHistoryFromFirebase()
        getInfoFromFirebase()
    }
    
    func getListsFromFirebase() {
        var newList = [TaskList]()
        ref = Database.database().reference()
        ref.child(userId).child("lists").observeSingleEvent(of: .value) { (snapshot) in
            var counter = 0
            for child in snapshot.children {
                let list = child as! DataSnapshot
                let dictionary = list.value as! [String: AnyObject]
                if let l = dictionary["listName"] {
                    if let i = dictionary["isPrivate"] {
                        if let a = dictionary["isActive"] {
                            let listName = l as! String
                            let isPrivate = i as! String
                            let isActive = a as! String
                            newList.append(TaskList(name: listName, isPrivate: Bool(isPrivate)!, isActive: Bool(isActive)!))
                        }
                    }
                }
                
                for child in list.childSnapshot(forPath: "tasks").children {
                    let task = child as! DataSnapshot
                    let dictionary = task.value as! [String: AnyObject]
                    if let n = dictionary["name"] {
                        if let p = dictionary["points"] {
                            if let c = dictionary["completed"] {
                                let name = n as! String
                                let points = p as! String
                                let completed = c as! String
                                newList[counter].addTask(Task(name, Int(points)!, Bool(completed)!))
                            }
                        }
                    }
                }
                counter += 1
            }
            listOfTaskLists = newList
            for list in listOfTaskLists {
                list.taskList.sort()
            }
            self.homeTableView.reloadData()
        }
    }
    
    func getHistoryFromFirebase () {
        var newList = [OneDaysHistory]()
        ref = Database.database().reference()
        
        ref.child(userId).child("history").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let history = child as! DataSnapshot
                let dictionary = history.value as! [String: AnyObject]
                let points = dictionary["points"] as! String
                let percent = dictionary["percent"] as! String
                let date = dictionary["date"] as! String
                let day = dictionary["day"] as! String
                newList.append(OneDaysHistory(points: Int(points)!, percent: Float(percent)!, date: date, day: day))
            }
            listOfHistory = newList
        }
    }
    
    func getInfoFromFirebase() {
        ref = Database.database().reference()
        let tbc = self.tabBarController as! TabBarController
        
        ref.child(userId).child("info").observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as? [String: AnyObject]
            
            if let dateToSave = dictionary?["dateToSave"]{
                self.dateToSave = dateToSave as! String
                tbc.dateToSave = dateToSave as! String
            } else {
                let dateFormatter = DateFormatter()
                let currentDate = Date()
                dateFormatter.dateFormat = "yyyyMMdd"
                let currentDateAsString = dateFormatter.string(from: currentDate)
                
                self.dateToSave = currentDateAsString
                tbc.dateToSave = currentDateAsString
                self.ref.child(userId).child("info").child("dateToSave").setValue(currentDateAsString)
                self.createEmptyHistory(currentDate)
            }
        }
    }
    
    func createEmptyHistory(_ currentDate: Date) {
        let dateFormatterYear = DateFormatter()
        dateFormatterYear.dateFormat = "yyyyMMdd"
        let dateFormatterDay = DateFormatter()
        dateFormatterDay.dateFormat = "EEE"
        var myComponent = DateComponents()
        for i in 1...7 {
            myComponent.day = i-8
            let newDate = Calendar.current.date(byAdding: myComponent, to: currentDate)
            let newDateAsString = dateFormatterYear.string(from: newDate!)
            let newDayAsString = dateFormatterDay.string(from: newDate!)
            ref.child(userId).child("history").child(String(listOfHistory.count)).child("points").setValue("0")
            ref.child(userId).child("history").child(String(listOfHistory.count)).child("percent").setValue("0.0")
            ref.child(userId).child("history").child(String(listOfHistory.count)).child("date").setValue(newDateAsString)
            ref.child(userId).child("history").child(String(listOfHistory.count)).child("day").setValue(newDayAsString)
            listOfHistory.append(OneDaysHistory(points: Int(0), percent: 0.0, date: newDateAsString, day: newDayAsString))
            print("appended history")
        }
    }
    
    // MARK: - Notifications
    @objc func saveIsActiveValue(_ notification: Notification) {
        let row = notification.userInfo!["tag"] as! Int
        let isActive = notification.userInfo!["isActive"] as! Bool
        for i in 0...listOfTaskLists.count - 1 {
            if !(row == i) {
                listOfTaskLists[i].isActive = false
                ref.child(userId).child("lists").child(String(i)).child("isActive").setValue("false")
            }
        }
        listOfTaskLists[row].isActive = isActive
        ref.child(userId).child("lists").child(String(row)).child("isActive").setValue(String(isActive))
        homeTableView.reloadData()
    }
    
    @objc func saveIsPrivateValue(_ notification: Notification) {
        let row = notification.userInfo!["tag"] as! Int
        let isPrivate = notification.userInfo!["isPrivate"] as! Bool
        ref.child(userId).child("lists").child(String(row)).child("isPrivate").setValue(String(isPrivate))
        listOfTaskLists[row].isPrivate = isPrivate
    }
    
    @objc func saveListValues(_ notification: Notification) {
        let title = notification.userInfo!["title"] as! String
        let isPrivate = notification.userInfo!["isPrivate"] as! Bool
        if editMode {
            let row = notification.userInfo!["tag"] as! Int
            ref.child(userId).child("lists").child(String(row)).child("listName").setValue(title)
            listOfTaskLists[row].name = title
        } else {
            ref = Database.database().reference()
            ref.child(userId).child("lists").child(String(listOfTaskLists.count)).child("listName").setValue(title)
            ref.child(userId).child("lists").child(String(listOfTaskLists.count)).child("isPrivate").setValue(String(isPrivate))
            ref.child(userId).child("lists").child(String(listOfTaskLists.count)).child("isActive").setValue(String("false"))
            
            listOfTaskLists.append(TaskList(name: title, isPrivate: isPrivate, isActive: false))
            editButton.isEnabled = true
        }
        homeTableView.reloadData()
    }
    
    // MARK: - TableView
    @IBAction func editBtnPressed(_ sender: UIBarButtonItem) {
        var title = "Edit"
        homeTableView.isEditing = !homeTableView.isEditing
        if homeTableView.isEditing {
            title = "Done"
        }
        editButton.title = title
        editMode = homeTableView.isEditing
        homeTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEditing {
            return listOfTaskLists.count
        } else {
            return listOfTaskLists.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == listOfTaskLists.count {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("HomeTableViewCell", owner: self, options: nil)?.first as! HomeTableViewCell
        let lastCell = Bundle.main.loadNibNamed("AddListTableViewCell", owner: self, options: nil)?.first as! AddListTableViewCell
        
        if tableView.isEditing {
            var segmentInt = 1
            if listOfTaskLists[indexPath.row].isPrivate {
                segmentInt = 0
            }
            lastCell.segmentedControl.isHidden = false
            lastCell.segmentedControl.tag = indexPath.row
            lastCell.segmentedControl.selectedSegmentIndex = segmentInt
            
            
            lastCell.textView.isHidden = false
            lastCell.textView.tag = indexPath.row
            lastCell.textView.text = listOfTaskLists[indexPath.row].name
            
            return lastCell
        }
        else {
            if indexPath.row == listOfTaskLists.count {
                if lastCellClicked {
                    lastCell.segmentedControl.isHidden = false
                    lastCell.segmentedControl.tag = -1
                    lastCell.textView.isHidden = false
                    lastCell.textView.becomeFirstResponder()
                    
                    lastCellClicked = false
                } else {
                   lastCell.textLabel?.text = "Click to add list"
                }
                return lastCell
            } else {
                cell.titleLabel.text = listOfTaskLists[indexPath.row].name
                if listOfTaskLists[indexPath.row].isPrivate {
                    cell.privateLabel.text = "Private"
                } else {
                    cell.privateLabel.text = "Public"
                }
                cell.cellSwitch.tag = indexPath.row
                cell.cellSwitch.isOn = listOfTaskLists[indexPath.row].isActive
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == listOfTaskLists.count {
            lastCellClicked = true
            editButton.isEnabled = false
            homeTableView.reloadData()
        } else {
            performSegue(withIdentifier: "toAddTask", sender: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            listOfTaskLists.remove(at: indexPath.row)
            ref.child(userId).child("lists").child(String(listOfTaskLists.count)).removeValue()
            
            for i in indexPath.row...listOfTaskLists.count {
                var a = i
                if a == 0 {
                    a = 1
                }
                var count = 0
                if listOfTaskLists.count != 0 {
                    if listOfTaskLists[a - 1].taskList.count == 0 {
                        let isActive = String(listOfTaskLists[a - 1].isActive)
                        let isPrivate = String(listOfTaskLists[a - 1].isPrivate)
                        let listName = listOfTaskLists[a - 1].name
                        
                        let path = ref.child(userId).child("lists").child(String(a - 1))
                        path.child("isActive").setValue(isActive)
                        path.child("isPrivate").setValue(isPrivate)
                        path.child("listName").setValue(listName)
                    }
                    
                    for task in listOfTaskLists[a - 1].taskList {
                        let name = task.name
                        let completed = String(task.completed)
                        let points = String(task.points)
                        let isActive = String(listOfTaskLists[a - 1].isActive)
                        let isPrivate = String(listOfTaskLists[a - 1].isPrivate)
                        let listName = listOfTaskLists[a - 1].name
                        
                        let shortPath = ref.child(userId).child("lists").child(String(a - 1))
                        shortPath.child("isActive").setValue(isActive)
                        shortPath.child("isPrivate").setValue(isPrivate)
                        shortPath.child("listName").setValue(listName)
                        
                        let path = shortPath.child("tasks").child(String(count))
                        path.child("completed").setValue(completed)
                        path.child("name").setValue(name)
                        path.child("points").setValue(points)
                        count += 1
                    }
                }
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addTaskViewController = segue.destination as? AddTaskViewController
        addTaskViewController?.selectedRow = sender as! Int
        addTaskViewController?.dateToSave = dateToSave
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "saveListValues"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "saveIsPrivateValue"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "saveIsActiveValue"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
