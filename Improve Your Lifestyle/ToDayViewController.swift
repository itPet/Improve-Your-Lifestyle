//
//  ToDayViewController.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-03-28.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit

class ToDayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var listOfTaskLists = [TaskList]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfTaskLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDayCell", for: indexPath)
        
        cell.textLabel?.text = listOfTaskLists[indexPath.row].name
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//    }
    
    
    
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
