//
//  DownloadTasksViewController.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-04-22.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit

class DownloadTasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedRow = 0
    var publicLists = [TaskList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicLists[selectedRow].taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = publicLists[selectedRow].taskList[indexPath.row].name
        return cell
    }
    
    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
