//
//  Picture.swift
//  Find3
//
//  Created by Susan Stevens on 5/13/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

//import SpriteKit
//
//class Picture: Printable, Hashable {
//    let property1: Int
//    let property2: Int
//    let property3: Int
//    var isOnscreen: Bool = false
//    
//    let imageNum: Int
//    let imageName: String
//    let glowImageName: String
//    var sprite: PictureSprite?
//    
//    var column: Int?
//    var row: Int?
//    
//    init(prop1: Int, prop2: Int, prop3: Int, imageNum: Int, level: String) {
//        self.property1 = prop1
//        self.property2 = prop2
//        self.property3 = prop3
//        self.imageNum = imageNum
//        self.imageName = level + "-" + "\(imageNum)"
//        self.glowImageName = self.imageName + "-glow"
//    }
//    
//    var description: String {
//        return imageName
//    }
//    
//    var hashValue: Int {
//        return imageNum
//    }
//    
//    class func createAllPictures(level: String) -> Array<Picture> {
//        var pictures = [Picture]()
//        var i = 0
//        for property1 in 0..<3 {
//            for property2 in 0..<3 {
//                for property3 in 0..<3 {
//                    let picture = Picture(prop1: property1, prop2: property2, prop3: property3, imageNum: i, level: level)
//                    pictures += [picture]
//                    i++
//                }
//            }
//        }
//        return pictures
//    }
//}
//
//func ==(lhs: Picture, rhs: Picture) -> Bool {
//    return lhs.imageNum == rhs.imageNum
//}