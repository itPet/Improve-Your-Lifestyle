//
//  TabBarController.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-03-28.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var placeOfHistoryCell = 0
    //var listOfTaskLists = [TaskList]()
    var listOfTaskLists = [TaskList(name: "Bra lista", taskList: [Task("Uppgift", 1), Task("Gå upp kl 7", 2), Task("Ät mat", 5), Task("Gå med hunden", 1), Task("Plugga en timme", 3), Task("Köp hundmat", 4)]), TaskList(name: "Lista", taskList: [Task("Hoppa", 1), Task("Gräva", 2), Task("Simma", 5), Task("Gå på toa", 1), Task("Baka", 3), Task("Flyg", 4)])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
