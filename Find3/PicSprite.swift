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

/// Class for an image in the game

class PicSprite: SKSpriteNode {
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
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        self.addAnimations(level)
        
        self.isUserInteractionEnabled = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
// MARK: - Class functions
    
    /// Create array of all 27 PicSprites for a given level
    class func createAll(_ level: Int) -> Array<PicSprite> {
        var sprites = [PicSprite]()
        var i = 0
        for property1 in 0..<3 {
            for property2 in 0..<3 {
                for property3 in 0..<3 {
                    let sprite = PicSprite(prop1: property1, prop2: property2, prop3: property3, imageNum: i, level: level)
                    sprites += [sprite]
                    i += 1
                }
            }
        }
        return sprites
    }
    
    /// Create array of 9 PicSprites used in example pages in tutorial
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
    
    /// Create array of 9 PicSprites used on the test page in tutorial
    class func createTutorialPics() -> Array<PicSprite> {
        var allSprites = createAll(1)
        var sprites = [PicSprite]()
        
        
        sprites += [allSprites[1]]
        sprites += [allSprites[3]]
        sprites += [allSprites[11]]
        
        sprites += [allSprites[13]]
        sprites += [allSprites[16]]
        sprites += [allSprites[17]]
        
        sprites += [allSprites[19]]
        sprites += [allSprites[21]]
        sprites += [allSprites[23]]
        
        sprites.shuffle()
        
        return sprites
    }
    
// MARK: - Selection and deselection
    
    /// Called when user selects a sprite
    func selectSprite() {
        
        let texture = SKTexture(imageNamed: "\(imageName)-glow")
        self.size = texture.size()
        self.texture = texture
        selected = true
        
    }
    
    /// Called when user deselects a sprite
    func deselectSprite() {
        
        let texture = SKTexture(imageNamed: imageName)
        self.size = texture.size()
        self.texture = texture
        selected = false
    
    }
    
// MARK: - Animations
    
    /** 
    Called when user selects a valid group of 3 images.
    Removes the images and resets rotation and selection properties of the sprites.
    */
    func runValidGroupAction() {
        
        removeAllActions()
        
        run(Animations.sharedInstance.validGroup)
        
        run(SKAction.wait(forDuration: 0.6), completion: {
            self.zRotation = 0.0
            self.deselectSprite()
            })
    }
    
    /// Called when user selects a valid group of 3 images in tutorial level
    func runTutorialValidGroupAction() {
        run(Animations.sharedInstance.tutorialValidGroup)
    }
    
    func runInvalidGroupAction() {
        
        run(Animations.sharedInstance.invalidGroup, completion: {
            self.deselectSprite()
        }) 
        
    }
    
// MARK: - Levels 8-10 animations
    
    /// Add actions to sprites in levels 8-10
    func addAnimations(_ level: Int) {
        
        removeAllActions()
        action = nil
        
        // let waitAction = SKAction.wait(forDuration: 0.5, withRange: 0.5)
        
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
    
}

func ==(lhs: PicSprite, rhs: PicSprite) -> Bool {
    return lhs.imageNum == rhs.imageNum
}
