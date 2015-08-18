//
//  PicSprite.swift
//  Find3
//
//  Created by Susan Stevens on 6/2/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit

// A PicSprite is one of the shapes displayed onscreen

class PicSprite: SKSpriteNode, Hashable {
    var selected: Bool = false
    var onscreen: Bool = false
    
    let property1: Int
    let property2: Int
    let property3: Int
    
    let imageNum: Int
    var imageName: String
    
    var column: Int?
    var row: Int?
    
    var action: SKAction?
    
    init(prop1: Int, prop2: Int, prop3: Int, imageNum: Int, level: Int) {
        self.property1 = prop1
        self.property2 = prop2
        self.property3 = prop3
        
        self.imageNum = imageNum
        
        if level == 8 || level == 9 || level == 10 {
            self.imageName = "level\(level)" + "-" + "\(imageNum % 9)"
        } else {
            self.imageName = "level\(level)" + "-" + "\(imageNum)"
        }
        
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: nil, size: texture.size())
        
        self.addAnimations(level)
        
        self.userInteractionEnabled = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    // Create all 27 PicSprites for a given level
    class func createAll(level: Int) -> Array<PicSprite> {
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
    
    class func createExamplePics() -> Array<PicSprite> {
        var allSprites = createAll(1)
        var sprites = [PicSprite]()
        
        sprites += [allSprites[10]]
        sprites += [allSprites[12]]
        sprites += [allSprites[17]]
        sprites += [allSprites[21]]
        sprites += [allSprites[3]]
        sprites += [allSprites[0]]
        sprites += [allSprites[2]]
        sprites += [allSprites[25]]
        sprites += [allSprites[9]]
        
        return sprites
    }
    
    // Return an array of the nine PicSprites used in the tutorial level
    class func createTutorialPics() -> Array<PicSprite> {
        var allSprites = createAll(1)
        var sprites = [PicSprite]()
        
        sprites += [allSprites[23]]
        sprites += [allSprites[3]]
        sprites += [allSprites[13]]
        sprites += [allSprites[11]]
        sprites += [allSprites[21]]
        sprites += [allSprites[16]]
        sprites += [allSprites[17]]
        sprites += [allSprites[1]]
        sprites += [allSprites[19]]
        
        sprites.shuffle()
        
        return sprites
    }
    
    // MARK: Animations
    
    func addAnimations(level: Int) {
        
        removeAllActions()
        action = nil
        
        let waitAction = SKAction.waitForDuration(0.5, withRange: 0.5)
        
        if level == 8 {
            
            if property1 == 0 {
                action = Animations.sharedInstance.dip
            } else if property1 == 1 {
                action = Animations.sharedInstance.shrink
            }
            
        } else if level == 9 {
            
            if property1 == 0 {
                action = Animations.sharedInstance.wobble
            } else if property1 == 1 {
                action = Animations.sharedInstance.stretch
            }
            
            
        } else if level == 10 {
            
            if property1 == 0 {
                action = Animations.sharedInstance.spin
            } else if property1 == 1 {
                action = Animations.sharedInstance.expand
            }
        }
    }
    
    // Called when user selects a sprite
    func selectSprite() {
        
        let texture = SKTexture(imageNamed: "\(imageName)-glow")
        self.size = texture.size()
        self.texture = texture
        selected = true
        
    }
    
    // Called when user deselects a sprite
    func deselectSprite() {
        
        let texture = SKTexture(imageNamed: imageName)
        self.size = texture.size()
        self.texture = texture
        selected = false
    
    }
    
    // Animations for removing a sprite from the screen
    func removeWithActions() {
        
        self.removeAllActions()
        
        runAction(Animations.sharedInstance.validGroup)
        
        runAction(SKAction.waitForDuration(0.6), completion: {
            self.zRotation = 0.0
            self.deselectSprite()
            })
    }
    
    // Animations for valid group (used in tutorial level)
    func expand() {
        
        self.runAction(Animations.sharedInstance.tutorialValidGroup)
        
    }
    
    // Animations for selections of invalid group
    func wiggleAndDeselect() {
        
        runAction(Animations.sharedInstance.invalidGroup) {
            self.deselectSprite()
        }
        
    }
}

func ==(lhs: PicSprite, rhs: PicSprite) -> Bool {
    return lhs.imageNum == rhs.imageNum
}
