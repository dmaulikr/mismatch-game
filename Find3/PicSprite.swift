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
        
        if level == 5 || level == 9 || level == 10 {
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
        
        sprites += [allSprites[17]]
        sprites += [allSprites[21]]
        sprites += [allSprites[2]]
        sprites += [allSprites[25]]
        sprites += [allSprites[12]]
        sprites += [allSprites[14]]
        sprites += [allSprites[10]]
        sprites += [allSprites[22]]
        sprites += [allSprites[0]]
        
        sprites[0].selectSprite()
        sprites[4].selectSprite()
        sprites[6].selectSprite()
        
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
        
        let waitAction = SKAction.waitForDuration(1.0, withRange: 1.0)
        
        if level == 5 {
            
            let spinAction = SKAction.rotateByAngle(CGFloat(M_PI), duration: 0.25)
            let spinSequence = SKAction.sequence([spinAction, SKAction.waitForDuration(1.0)])
            
            let expandAction = SKAction.scaleBy(1.1, duration: 0.2)
            let expandSequence = SKAction.sequence([expandAction, expandAction.reversedAction(),
                SKAction.waitForDuration(1.0)])
            
            if property1 == 0 {
                action = SKAction.sequence([waitAction, SKAction.repeatActionForever(spinSequence)])
            } else if property1 == 1 {
                action = SKAction.sequence([waitAction, SKAction.repeatActionForever(expandSequence)])
            }
            
        } else if level == 9 {
            
            let dipAction = SKAction.rotateByAngle(-CGFloat(M_PI / 8.0), duration: 0.1)
            let dipSequence = SKAction.sequence([dipAction, dipAction.reversedAction(),
                SKAction.waitForDuration(1.0)])
            
            let shrinkAction = SKAction.scaleBy(0.8, duration: 0.5)
            let shrinkSequence = SKAction.sequence([shrinkAction, shrinkAction.reversedAction(), SKAction.waitForDuration(0.5)])
            
            if property1 == 0 {
                action = SKAction.sequence([waitAction, SKAction.repeatActionForever(dipSequence)])
            } else if property1 == 1 {
                action = SKAction.sequence([waitAction, SKAction.repeatActionForever(shrinkSequence)])
            }
            
            
        } else if level == 10 {
            
            let wobbleRightAction = SKAction.rotateByAngle(-CGFloat(M_PI / 6.0), duration: 0.4)
            let wobbleLeftAction = SKAction.rotateByAngle(CGFloat(M_PI / 6.0), duration: 0.4)
            let wobbleSequence = SKAction.sequence([wobbleRightAction, wobbleRightAction.reversedAction(), wobbleLeftAction, wobbleLeftAction.reversedAction()])
            
            let stretchAction = SKAction.scaleXBy(1.2, y: 1.0, duration: 0.1)
            let stretchSequence = SKAction.sequence([stretchAction, stretchAction.reversedAction(),
                stretchAction, stretchAction.reversedAction(), SKAction.waitForDuration(1.0)])
            
//            let fadeOutAction = SKAction.fadeAlphaTo(0.2, duration: 0.5)
//            let fadeInAction = SKAction.fadeAlphaTo(1.0, duration: 0.2)
//            let fadeSequence = SKAction.sequence([fadeOutAction, fadeInAction, SKAction.waitForDuration(1.0)])
            
            if property1 == 0 {
                action = SKAction.sequence([waitAction, SKAction.repeatActionForever(wobbleSequence)])
            } else if property1 == 1 {
                action = SKAction.sequence([waitAction, SKAction.repeatActionForever(stretchSequence)])
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
        
        let width = self.frame.width
        let height = self.frame.height
        
        let growAction = SKAction.resizeByWidth(10, height: 10, duration: 0.3)
        growAction.timingMode = .EaseIn
        
        let playValidSound = SKAction.runBlock {
            if !Sounds.sharedInstance.validGroupSound.playing {
                Sounds.sharedInstance.validGroupSound.play()
            }
        }
        
        let shrinkAction = SKAction.resizeByWidth(-width, height: -height, duration: 0.2)
        shrinkAction.timingMode = .EaseOut
        
        self.runAction(SKAction.sequence([growAction, playValidSound, shrinkAction, SKAction.removeFromParent()]))
        
        runAction(SKAction.waitForDuration(0.6), completion: {
            self.deselectSprite()
            })
    }
    
    // Animations for valid group (used in tutorial level)
    func expand() {
        let expand = SKAction.resizeByWidth(10, height: 10, duration: 0.3)
        expand.timingMode = .EaseIn
        
        let resize = SKAction.resizeByWidth(-10, height: -10, duration: 0.3)
        resize.timingMode = .EaseOut
        
        self.runAction(SKAction.sequence([expand, resize]))
        
    }
    
    // Animations for selections of invalid group
    func wiggleAndDeselect() {
        
        let playInvalidSound = SKAction.runBlock {
            if !Sounds.sharedInstance.invalidGroupSound.playing {
                Sounds.sharedInstance.invalidGroupSound.play()
            }
        }
        
        let originalPosition = position.x
        let leftPosition = position.x - 5.0
        let rightPosition = position.x + 5.0
        
        let moveLeft = SKAction.moveToX(leftPosition, duration: 0.05)
        let moveRight = SKAction.moveToX(rightPosition, duration: 0.05)
        
        let wiggle = SKAction.sequence([moveLeft, moveRight])
        let repeatedWiggle = SKAction.repeatAction(wiggle, count: 4)
        
        runAction(SKAction.sequence([playInvalidSound, repeatedWiggle, SKAction.moveToX(originalPosition, duration: 0.1)])) {
            self.deselectSprite()
        }
    }
}

func ==(lhs: PicSprite, rhs: PicSprite) -> Bool {
    return lhs.imageNum == rhs.imageNum
}
