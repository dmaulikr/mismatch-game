//
//  Animations.swift
//  Find3
//
//  Created by Susan Stevens on 8/17/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import Foundation
import SpriteKit

/// Singleton class for PicSprite actions
class Animations {

    var tutorialValidGroup  = SKAction()
    var validGroup          = SKAction()
    var invalidGroup        = SKAction()
    
    // Actions used in levels 8-10
    
    var dip     = SKAction()
    var shrink  = SKAction()
    var wobble  = SKAction()
    var stretch = SKAction()
    var spin    = SKAction()
    var expand  = SKAction()
    
    let wait    = SKAction.wait(forDuration: 0.5, withRange: 0.5)
    
    static let sharedInstance = Animations()
    
    fileprivate init() {
        
        (tutorialValidGroup, validGroup) = validGroupActions()
        
        invalidGroup        = invalidGroupAction()
        
        (dip, shrink)       = level8Actions()
        (wobble, stretch)   = level9Actions()
        (spin, expand)      = level10Actions()
        
    }
    
// MARK: - Actions for all levels
    
    /** 
    Create actions used when user selects valid group of 3 images.
    Return tuple consisting of tutorial action and level action.
    */
    
    func validGroupActions() -> (SKAction, SKAction) {
        
        let grow = SKAction.resize(byWidth: 10, height: 10, duration: 0.3)
        grow.timingMode = .easeIn
        
        let playValidSound = SKAction.run {
            if !Sounds.sharedInstance.validGroupSound.isPlaying {
                Sounds.sharedInstance.validGroupSound.play()
            }
        }
        
        let disappear = SKAction.resize(byWidth: -80, height: -80, duration: 0.2)
        disappear.timingMode = .easeOut
        
        let validGroupSequence = SKAction.sequence([grow, playValidSound, disappear, SKAction.removeFromParent()])
        
         return (SKAction.sequence([grow, grow.reversed()]), validGroupSequence)
        
    }
    
    /// Create action used when user selects invalid group of 3 images
    func invalidGroupAction() -> SKAction {
        
        let moveRight = SKAction.moveBy(x: 5.0, y: 0.0, duration: 0.025)
        let moveLeft = SKAction.moveBy(x: -5.0, y: 0.0, duration: 0.025)
        
        let wiggle = SKAction.sequence([moveLeft, moveLeft.reversed(), moveRight, moveRight.reversed()])
        
        let playInvalidSound = SKAction.run {
            if !Sounds.sharedInstance.invalidGroupSound.isPlaying {
                Sounds.sharedInstance.invalidGroupSound.play()
            }
        }
        
        return SKAction.sequence([playInvalidSound, SKAction.repeat(wiggle, count: 4)])
        
    }
    
// MARK: - Actions for levels 8-10
    
    /// Create 2 actions used as properties in level 8
    func level8Actions() -> (SKAction, SKAction) {
        
        // Property 0: dip action
        
        let dipAction = SKAction.rotate(byAngle: -(CGFloat.pi / 8.0), duration: 0.1)
        let dipSequence = SKAction.sequence([dipAction, dipAction.reversed(),
            SKAction.wait(forDuration: 1.0)])
        
        // Property 1: shrink action
        
        let shrinkAction = SKAction.resize(byWidth: -10, height: -10, duration: 0.5)
        let shrinkSequence = SKAction.sequence([shrinkAction, shrinkAction.reversed(), SKAction.wait(forDuration: 0.5)])
        
        return (waitAndRepeatActionForever(dipSequence),
                waitAndRepeatActionForever(shrinkSequence))
    }
    
    /// Create 2 actions used as properties in level 9
    func level9Actions() -> (SKAction, SKAction) {
        
        // Property 0: wobble action
        
        let wobbleRightAction = SKAction.rotate(byAngle: -(CGFloat.pi / 6), duration: 0.4)
        let wobbleLeftAction = SKAction.rotate(byAngle: (CGFloat.pi / 6.0), duration: 0.4)
        let wobbleSequence = SKAction.sequence([wobbleRightAction, wobbleRightAction.reversed(), wobbleLeftAction, wobbleLeftAction.reversed()])
        
        // Property 1: stretch action
        
        let stretchAction = SKAction.scaleX(by: 1.2, y: 1.0, duration: 0.1)
        let stretchSequence = SKAction.sequence([stretchAction, stretchAction.reversed(),
            stretchAction, stretchAction.reversed(), SKAction.wait(forDuration: 1.0)])
        
        return (waitAndRepeatActionForever(wobbleSequence),
                waitAndRepeatActionForever(stretchSequence))
        
    }
    
    /// Create 2 actions used as properties in level 10
    func level10Actions() -> (SKAction, SKAction) {
        
        // Property 0: spin action
        
        let spinAction = SKAction.rotate(byAngle: CGFloat.pi, duration: 0.25)
        let spinSequence = SKAction.sequence([spinAction, SKAction.wait(forDuration: 1.0)])
        
        // Property 1: expand action
        
        let expandAction = SKAction.scale(by: 1.1, duration: 0.2)
        let expandSequence = SKAction.sequence([expandAction, expandAction.reversed(),
            SKAction.wait(forDuration: 1.0)])
        
        return (waitAndRepeatActionForever(spinSequence),
                waitAndRepeatActionForever(expandSequence))
    }
    
    /** 
    Helper function that takes an action and returns an action sequence
    consisting of a random-duration wait and the action repeated forever.
    */
    func waitAndRepeatActionForever(_ action: SKAction) -> SKAction {
        return SKAction.sequence([wait, SKAction.repeatForever(action)])
    }
    
}
