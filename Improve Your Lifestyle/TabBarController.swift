//
//  TabBarController.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-03-28.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var dateToSave = ""
    
    @IBOutlet weak var tabBarBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarBar.backgroundColor = headerAndFooterColor
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
