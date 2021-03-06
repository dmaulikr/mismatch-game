//
//  Extensions.swift
//  Find3
//
//  Created by Susan Stevens on 5/13/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
