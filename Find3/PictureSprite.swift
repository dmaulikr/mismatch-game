//
//  PictureSprite.swift
//  Find3
//
//  Created by Susan Stevens on 5/15/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import Foundation
import SpriteKit

class PictureSprite: SKSpriteNode {
    var selected: Bool = false
    let imageName: String
    let glowImageName: String
    
    init(position: CGPoint, imageName: String) {
        let texture = SKTexture(imageNamed: imageName)
        self.imageName = imageName
        self.glowImageName = "\(imageName)-glow"
        super.init(texture: texture, color: nil, size: texture.size())
        self.position = position
        self.userInteractionEnabled = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    func selectSprite() {
        let texture = SKTexture(imageNamed: glowImageName)
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
        let growAction = SKAction.scaleTo(1.1, duration: 0.3)
        growAction.timingMode = .EaseIn
        let shrinkAction = SKAction.scaleTo(0.1, duration: 0.3)
        shrinkAction.timingMode = .EaseOut
        self.runAction(SKAction.sequence([growAction, shrinkAction, SKAction.removeFromParent()]))
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
