//
//  DownloadTasksViewController.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-04-22.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit

class DownloadTasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var downloadTaskTableView: UITableView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadTaskTableView.tableFooterView = UIView(frame: CGRect.zero)
        navigationTitle.title = publicLists[selectedRow].name
        setColors()
    }
    
    func setColors() {
        view.backgroundColor = UIColor.black
        downloadTaskTableView.backgroundColor = tableViewBackgroundColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicLists[selectedRow].taskList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CustomTableViewCell", owner: self, options: nil)?.first as! CustomTableViewCell
        
        cell.nameLabel.text = publicLists[selectedRow].taskList[indexPath.row].name
        cell.pointsLabel.text = String(publicLists[selectedRow].taskList[indexPath.row].points)
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
