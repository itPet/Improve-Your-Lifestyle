//
//  TaskList.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-03-21.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import Foundation

class TaskList {
    
    var taskList = [Task]()
    var name : String
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, taskList: [Task]) {
        self.name = name
        self.taskList = taskList
    }
    
    func addTask(_ task: Task) {
        taskList.append(task)
    }
    
    
}
