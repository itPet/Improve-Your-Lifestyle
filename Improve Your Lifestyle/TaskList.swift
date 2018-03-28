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
    
    func addTask(_ task: Task) {
        taskList.append(task)
    }
    
    func addTask(_ task1: Task,_ task2: Task,_ task3: Task,_ task4: Task,_ task5: Task) {
        taskList.append(task1)
        taskList.append(task2)
        taskList.append(task3)
        taskList.append(task4)
        taskList.append(task5)
    }
    
}
