//
//  AddTaskViewController.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-03-19.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var nameTextField: UITextView!
    @IBOutlet weak var pointsTextField: UITextView!
    @IBOutlet weak var addedTasksTableView: UITableView!
    
    
    var taskList = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addedTasksTableView.dataSource = self
        addedTasksTableView.delegate = self
    }
    
    @IBAction func addTaskBtnPressed(_ sender: UIBarButtonItem) {
        popUpView.isHidden = false
    }
    
    @IBAction func doneBtnPressed(_ sender: UIButton) {
        taskList.append(Task(name: nameTextField.text, points: Int(pointsTextField.text)!))
        
        popUpView.isHidden = true
        addedTasksTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = taskList[indexPath.row].name
        cell?.detailTextLabel?.text = String(taskList[indexPath.row].points)
        return cell!
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
