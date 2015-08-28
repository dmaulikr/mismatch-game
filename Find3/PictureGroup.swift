//
//  PictureGroup.swift
//  Find3
//
//  Created by Susan Stevens on 5/15/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import Foundation

/// Struct consisting of three PicSprites that may or may not form a valid group

struct PictureGroup: Printable {
    let pictureA: PicSprite
    let pictureB: PicSprite
    let pictureC: PicSprite
    
    init(pictureA: PicSprite, pictureB: PicSprite, pictureC: PicSprite) {
        self.pictureA = pictureA
        self.pictureB = pictureB
        self.pictureC = pictureC
    }
    
    /// Check the three properties of each PicSprite in the group
    func isValid() -> Bool {
        return checkProperty1() && checkProperty2() && checkProperty3()
    }
    
    /// Determine whether the first property is the same or unique for 3 PicSprites
    private func checkProperty1() -> Bool {
        if pictureA.property1 == pictureB.property1 {
            return pictureA.property1 == pictureC.property1 && pictureB.property1 == pictureC.property1
        } else {
            return pictureA.property1 != pictureC.property1 && pictureB.property1 != pictureC.property1
        }
    }
    
    /// Determine whether the second property is the same or unique for 3 PicSprites
    private func checkProperty2() -> Bool {
        if pictureA.property2 == pictureB.property2 {
            return pictureA.property2 == pictureC.property2 && pictureB.property2 == pictureC.property2
        } else {
            return pictureA.property2 != pictureC.property2 && pictureB.property2 != pictureC.property2
        }
    }
    
    /// Determine whether the third property is the same or unique for 3 PicSprites
    private func checkProperty3() -> Bool {
        if pictureA.property3 == pictureB.property3 {
            return pictureA.property3 == pictureC.property3 && pictureB.property3 == pictureC.property3
        } else {
            return pictureA.property3 != pictureC.property3 && pictureB.property3 != pictureC.property3
        }
    }
    
    var description: String {
        return "\(pictureA.imageName), \(pictureB.imageName), \(pictureC.imageName)"
    }
}

func ==(lhs: PictureGroup, rhs: PictureGroup) -> Bool {
    
    var lhsSet = Set<PicSprite>()
    lhsSet.insert(lhs.pictureA)
    lhsSet.insert(lhs.pictureB)
    lhsSet.insert(lhs.pictureC)
    
    return lhsSet.contains(rhs.pictureA) && lhsSet.contains(rhs.pictureB) && lhsSet.contains(rhs.pictureC)
}