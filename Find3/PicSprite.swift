//
//  PicSprite.swift
//  Find3
//
//  Created by Susan Stevens on 6/2/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import Foundation
import SpriteKit

class PicSprite: SKSpriteNode, Hashable {
    var selected: Bool = false
    var onscreen: Bool = false
    
    let property1: Int
    let property2: Int
    let property3: Int
    
    let imageNum: Int
    let imageName: String
    
    var column: Int?
    var row: Int?
    
    init(prop1: Int, prop2: Int, prop3: Int, imageNum: Int, level: String) {
        self.property1 = prop1
        self.property2 = prop2
        self.property3 = prop3
        
        self.imageNum = imageNum
        
        if level == "level4" {
            self.imageName = level + "-" + "\(imageNum % 9)"
        } else if level == "level5" {
            self.imageName = "level1-\(imageNum)"
        } else {
            self.imageName = level + "-" + "\(imageNum)"
        }
        
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: nil, size: texture.size())
        
        if level == "level4" {
            let rotateAction = SKAction.rotateByAngle(0.7853981634, duration: 0.5)
            
            if property1 == 0 {
                self.runAction(SKAction.repeatActionForever(SKAction.sequence([rotateAction])))
            }
            
            let largerAction = SKAction.resizeByWidth(15, height: 15, duration: 1.0)
            let smallerAction = SKAction.resizeByWidth(-15, height: -15, duration: 1.0)
            
            if property1 == 1 {
                self.runAction(SKAction.repeatActionForever(SKAction.sequence([largerAction, smallerAction])))
            }
        }
        
        self.userInteractionEnabled = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    class func createAll(level: String, layer: SKNode) -> Array<PicSprite> {
        var sprites = [PicSprite]()
        var i = 0
        for property1 in 0..<3 {
            for property2 in 0..<3 {
                for property3 in 0..<3 {
                    let sprite = PicSprite(prop1: property1, prop2: property2, prop3: property3, imageNum: i, level: level)
                    sprites += [sprite]
                    sprite.name = "Shape"
                    i++
                }
            }
        }
        return sprites
    }
    
    // MARK: Animations
    
    func selectSprite() {
        let texture = SKTexture(imageNamed: "\(imageName)-glow")
        self.size = texture.size()
        self.texture = texture
        selected = true
    }
    
    func deselectSprite() {
        let texture = SKTexture(imageNamed: imageName)
        self.size = texture.size()
        self.texture = texture
        selected = false
    }
    
    func removeWithActions() {
        
        let width = self.frame.width
        let height = self.frame.height
        
        let growAction = SKAction.resizeByWidth(10, height: 10, duration: 0.3)
        growAction.timingMode = .EaseIn
        
        let shrinkAction = SKAction.resizeByWidth(-width, height: -height, duration: 0.2)
        shrinkAction.timingMode = .EaseOut
        
        self.runAction(SKAction.sequence([growAction, shrinkAction, SKAction.removeFromParent()]))
        
        runAction(SKAction.waitForDuration(0.6), completion: {
            self.deselectSprite()
            })
    }
    
    func wiggleAndDeselect() {
        
        let originalPosition = position.x
        let leftPosition = position.x - 5.0
        let rightPosition = position.x + 5.0
        
        let moveLeft = SKAction.moveToX(leftPosition, duration: 0.07)
        let moveRight = SKAction.moveToX(rightPosition, duration: 0.07)
        
        let wiggle = SKAction.sequence([moveLeft, moveRight])
        let repeatedWiggle = SKAction.repeatAction(wiggle, count: 4)
        
        runAction(SKAction.sequence([repeatedWiggle, SKAction.moveToX(originalPosition, duration: 0.1)])) {
            self.deselectSprite()
        }
    }

}

func ==(lhs: PicSprite, rhs: PicSprite) -> Bool {
    return lhs.imageNum == rhs.imageNum
}
