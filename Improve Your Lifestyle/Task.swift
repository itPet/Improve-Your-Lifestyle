//
//  Task.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-03-19.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import Foundation

class Task : Comparable {
    
    var name : String
    var points : Int
    var completed : Bool
    
    init(_ name: String, _ points: Int) {
        self.name = name
        self.points = points
        self.completed = false
    }
    
    init(_ name: String, _ points: Int, _ completed: Bool) {
        self.name = name
        self.points = points
        self.completed = completed
    }
    
    init(name: String, points: Int) {
        self.name = name
        self.points = points
        self.completed = false
    }
    
    init(name: String, points: AnyObject){
        self.name = name
        let p = points as! String
        self.points = Int(p)!
        self.completed = false
    }
    
    static func < (lhs: Task, rhs: Task) -> Bool {
        return lhs.completed && !rhs.completed
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.completed && rhs.completed
    }
    
}
