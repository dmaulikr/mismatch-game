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
    let imageName: String
    
    var column: Int?
    var row: Int?
    
    var selectSound = AVAudioPlayer()
    var dropSound = AVAudioPlayer()
    var validGroupSound = AVAudioPlayer()
    var invalidGroupSound = AVAudioPlayer()
    
    init(prop1: Int, prop2: Int, prop3: Int, imageNum: Int, level: Int) {
        self.property1 = prop1
        self.property2 = prop2
        self.property3 = prop3
        
        self.imageNum = imageNum
        
        if level == 5 || level == 9 {
            self.imageName = "level\(level)" + "-" + "\(imageNum % 9)"
        } else if level == 10 {
            self.imageName = "level1-\(imageNum)"
        } else {
            self.imageName = "level\(level)" + "-" + "\(imageNum)"
        }
        
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: nil, size: texture.size())
        
        if level == 5 {
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

    func setupAudioPlayer(file: String, type: String) -> AVAudioPlayer {
        var path = NSBundle.mainBundle().pathForResource(file, ofType: type)
        var url = NSURL.fileURLWithPath(path!)
        
        var error: NSError?
        
        var audioPlayer: AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        
        return audioPlayer!
    }
}

func ==(lhs: PicSprite, rhs: PicSprite) -> Bool {
    return lhs.imageNum == rhs.imageNum
}
