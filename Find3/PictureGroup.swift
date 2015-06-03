//
//  PictureGroup.swift
//  Find3
//
//  Created by Susan Stevens on 5/15/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import Foundation

struct PictureGroup: Hashable, Printable {
    let pictureA: PicSprite
    let pictureB: PicSprite
    let pictureC: PicSprite
    
    init(pictureA: PicSprite, pictureB: PicSprite, pictureC: PicSprite) {
        self.pictureA = pictureA
        self.pictureB = pictureB
        self.pictureC = pictureC
    }
    
    func isValidGroup() -> Bool {
        return checkProperty1() && checkProperty2() && checkProperty3()
    }
    
    private func checkProperty1() -> Bool {
        if pictureA.property1 == pictureB.property1 {
            return pictureA.property1 == pictureC.property1 && pictureB.property1 == pictureC.property1
        } else {
            return pictureA.property1 != pictureC.property1 && pictureB.property1 != pictureC.property1
        }
    }
    
    private func checkProperty2() -> Bool {
        if pictureA.property2 == pictureB.property2 {
            return pictureA.property2 == pictureC.property2 && pictureB.property2 == pictureC.property2
        } else {
            return pictureA.property2 != pictureC.property2 && pictureB.property2 != pictureC.property2
        }
    }
    
    private func checkProperty3() -> Bool {
        if pictureA.property3 == pictureB.property3 {
            return pictureA.property3 == pictureC.property3 && pictureB.property3 == pictureC.property3
        } else {
            return pictureA.property3 != pictureC.property3 && pictureB.property3 != pictureC.property3
        }
    }
    
    var hashValue: Int {
        return pictureA.hashValue ^ pictureB.hashValue ^ pictureC.hashValue
    }
    
    var description: String {
        return "Group: \(pictureA.imageName), \(pictureB.imageName), \(pictureC.imageName)"
    }
}

func ==(lhs: PictureGroup, rhs: PictureGroup) -> Bool {
    
    var lhsSet = Set<PicSprite>()
    lhsSet.insert(lhs.pictureA)
    lhsSet.insert(lhs.pictureB)
    lhsSet.insert(lhs.pictureC)
    
    return lhsSet.contains(rhs.pictureA) && lhsSet.contains(rhs.pictureB) && lhsSet.contains(rhs.pictureC)
}