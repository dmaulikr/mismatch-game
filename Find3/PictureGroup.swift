//
//  PictureGroup.swift
//  Find3
//
//  Created by Susan Stevens on 5/15/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import Foundation

struct PictureGroup: Hashable, Printable {
    let pictureA: Picture
    let pictureB: Picture
    let pictureC: Picture
    
    init(pictureA: Picture, pictureB: Picture, pictureC: Picture) {
        self.pictureA = pictureA
        self.pictureB = pictureB
        self.pictureC = pictureC
    }
    
    func isValidGroup() -> Bool {
        return checkShapeTypes() && checkColorTypes() && checkPatternTypes()
    }
    
    private func checkShapeTypes() -> Bool {
        if pictureA.shapeType == pictureB.shapeType {
            return pictureA.shapeType == pictureC.shapeType && pictureB.shapeType == pictureC.shapeType
        } else {
            return pictureA.shapeType != pictureC.shapeType && pictureB.shapeType != pictureC.shapeType
        }
    }
    
    private func checkColorTypes() -> Bool {
        if pictureA.colorType == pictureB.colorType {
            return pictureA.colorType == pictureC.colorType && pictureB.colorType == pictureC.colorType
        } else {
            return pictureA.colorType != pictureC.colorType && pictureB.colorType != pictureC.colorType
        }
    }
    
    private func checkPatternTypes() -> Bool {
        if pictureA.patternType == pictureB.patternType {
            return pictureA.patternType == pictureC.patternType && pictureB.patternType == pictureC.patternType
        } else {
            return pictureA.patternType != pictureC.patternType && pictureB.patternType != pictureC.patternType
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
    
    var lhsSet = Set<Picture>()
    lhsSet.insert(lhs.pictureA)
    lhsSet.insert(lhs.pictureB)
    lhsSet.insert(lhs.pictureC)
    
    return lhsSet.contains(rhs.pictureA) && lhsSet.contains(rhs.pictureB) && lhsSet.contains(rhs.pictureC)
}