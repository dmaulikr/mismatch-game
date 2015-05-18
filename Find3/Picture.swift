//
//  Picture.swift
//  Find3
//
//  Created by Susan Stevens on 5/13/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import SpriteKit

// Reference: http://stackoverflow.com/questions/24007461/how-to-enumerate-an-enum-with-string-type

enum ShapeType: Int {
    case Unknown = 0, Circle, Square, Triangle
    static let allValues = [Circle, Square, Triangle]
    
    var shapeName: String {
        let shapeNames = [
        "Circle",
        "Square",
        "Triangle"]
        
        return shapeNames[rawValue - 1]
    }
    
    var description: String {
        return shapeName
    }
}

enum ColorType: Int {
    case Unknown = 0, Purple, Orange, Green
    static let allValues = [Purple, Orange, Green]
    
    var colorName: String {
        let colorNames = [
            "Purple",
            "Orange",
            "Green"]
        
        return colorNames[rawValue - 1]
    }
    
    var description: String {
        return colorName
    }
}

enum PatternType: Int {
    case Unknown = 0, Grid, Stripes, Dots
    static let allValues = [Grid, Stripes, Dots]
    
    var patternName: String {
        let patternNames = [
            "Grid",
            "Stripes",
            "Dots"]
        
        return patternNames[rawValue - 1]
    }
    
    var description: String {
        return patternName
    }
}


class Picture: Printable, Hashable {
    let shapeType: ShapeType
    let colorType: ColorType
    let patternType: PatternType
    
    let number: Int
    let imageName: String
    var sprite: PictureSprite?
    
    var column: Int?
    var row: Int?
    
    init(shapeType: ShapeType, colorType: ColorType, patternType: PatternType, number: Int) {
        self.shapeType = shapeType
        self.colorType = colorType
        self.patternType = patternType
        self.number = number
        self.imageName = "picture\(number)"
    }
    
    var description: String {
        return "shape: \(shapeType), color: \(colorType), pattern: \(patternType), number: \(number)"
    }
    
    var hashValue: Int {
        return number
    }
    
    class func createAllPictures() -> Array<Picture> {
        var pictures = [Picture]()
        var i = 0
        for shape in ShapeType.allValues {
            for color in ColorType.allValues {
                for pattern in PatternType.allValues {
                    let picture = Picture(shapeType: shape, colorType: color, patternType: pattern, number: i)
                    pictures += [picture]
                    i++
                }
            }
        }
        return pictures
    }
    
}

func ==(lhs: Picture, rhs: Picture) -> Bool {
    return lhs.number == rhs.number
}