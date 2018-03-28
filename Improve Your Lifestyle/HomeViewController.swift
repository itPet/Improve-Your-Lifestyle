//
//  HomeViewController.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-03-26.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var sampleList = TaskList(name: "Uppgifter")
    var sampleList2 = TaskList(name: "Viktiga saker")
    var listOfTaskLists = [TaskList]()
    var willAppend = true
    var selectedRow = 0
    
    
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let toDayViewController = self.tabBarController?.viewControllers![1] as! ToDayViewController
//        
//        sampleList.addTask(Task("Gå upp kl 7", 2), Task("Ät mat", 5), Task("Gå med hunden", 1), Task("Plugga en timme", 3), Task("Köp hundmat", 4))
//        sampleList2.addTask(Task("Gör nått viktigt", 5))
//        
//        listOfTaskLists.append(sampleList)
//        listOfTaskLists.append(sampleList2)
//        
//        toDayViewController.listOfTaskLists = listOfTaskLists
        //homeTableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        homeTableView.reloadData()
        willAppend = true
        print(listOfTaskLists)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfTaskLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)
        
        cell.textLabel?.text = listOfTaskLists[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        willAppend = false
        selectedRow = indexPath.row
        
        performSegue(withIdentifier: "toAddTask", sender: AnyObject.self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addTaskViewController = segue.destination as? AddTaskViewController
        
        addTaskViewController?.listOfTaskLists = listOfTaskLists
        addTaskViewController?.willAppend = willAppend
        addTaskViewController?.selectedRow = selectedRow
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
