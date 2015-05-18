//
//  HighScore.swift
//  Find3
//
//  Created by Susan Stevens on 5/16/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import Foundation

struct HighScore {
    let score: Int
    let date: NSDate
    
    init(score: Int, date: NSDate) {
        self.score = score
        self.date = date
    }
}