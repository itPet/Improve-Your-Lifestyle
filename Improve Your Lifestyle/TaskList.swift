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
    var isPrivate : Bool
    var isActive : Bool
    
    
    init(name: String, isPrivate: Bool) {
        self.name = name
        self.isPrivate = isPrivate
        self.isActive = false
    }
    
    init(name: String, isPrivate: Bool, isActive: Bool) {
        self.name = name
        self.isPrivate = isPrivate
        self.isActive = isActive
    }
    
    init(name: String, taskList: [Task]) {
        self.name = name
        self.taskList = taskList
        self.isActive = false
        self.isPrivate = true
    }
    
    func addTask(_ task: Task) {
        taskList.append(task)
    }
    
    func addTasks() {
        
    }
    
    
}
