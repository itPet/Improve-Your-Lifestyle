//
//  DownloadViewController.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-04-20.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit
import Firebase

var publicLists = [TaskList]()
var downloadedRows = [Int]()

class DownloadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ref: DatabaseReference!
    var selectedRow = 0
    
    @IBOutlet weak var downloadsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFirebase()

        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView(notification:)), name: Notification.Name(rawValue: "updateTableView"), object: nil)
    }
    
    @objc func updateTableView(notification: Notification) {
        downloadsTableView.reloadData()
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("DownloadTableViewCell", owner: self, options: nil)?.first as! DownloadTableViewCell
        cell.textLabel?.text = publicLists[indexPath.row].name
        cell.downloadIcon.tag = indexPath.row
        
        if downloadedRows.contains(indexPath.row) {
            cell.downloadIcon.isHidden = true
            cell.downloadLabel.isHidden = false        
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "toDownloadTasks", sender: (Any).self)
    }
    
    // MARK: - Fireabse
    func getDataFromFirebase() {
        
        ref = Database.database().reference()
        ref.observe(.value) { (snapshot) in
            var newList = [TaskList]()
            var counter = 0
            var shouldAppend = true
            for child in snapshot.children {
                let user = child as! DataSnapshot
                if user.key != userId {
                    for child in user.childSnapshot(forPath: "lists").children {
                        let list = child as! DataSnapshot
                        let dictionary = list.value as! [String: AnyObject]
                        if let l = dictionary["listName"] {
                            if let i = dictionary["isPrivate"] {
                                let listName = l as! String
                                let isPrivate = i as! String
                                shouldAppend = !Bool(isPrivate)!
                                if shouldAppend {
                                    newList.append(TaskList(name: listName, isPrivate: true, isActive: false))
                                }
                            }
                        }
                        if shouldAppend {
                            for child in list.childSnapshot(forPath: "tasks").children {
                                let task = child as! DataSnapshot
                                let dictionary = task.value as! [String: AnyObject]
                                if let n = dictionary["name"] {
                                    if let p = dictionary["points"] {
                                        let name = n as! String
                                        let points = p as! String
                                        newList[counter].addTask(Task(name, Int(points)!, false))
                                    }
                                }
                            }
                        counter += 1
                        }
                    }
                }
            }
            print("newList: \(newList.count)")
            publicLists = newList
            self.downloadsTableView.reloadData()
        }
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let downloadTaskVC = segue.destination as! DownloadTasksViewController
        downloadTaskVC.publicLists = publicLists
        downloadTaskVC.selectedRow = selectedRow
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
