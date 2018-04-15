//
//  OneDaysHistory.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-04-15.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import Foundation

class OneDaysHistory {
    var points : Int
    var percent : Float
    var date : String
    var day : String
    
    init (points: Int, percent: Float, date: String, day: String) {
        self.points = points
        self.percent = percent
        self.date = date
        self.day = day
    }
    
}
