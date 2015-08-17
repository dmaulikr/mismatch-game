//
//  Animations.swift
//  Find3
//
//  Created by Susan Stevens on 8/17/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import Foundation
import SpriteKit

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
    
    let wait    = SKAction.waitForDuration(0.5, withRange: 0.5)
    
    static let sharedInstance = Animations()
    
    private init() {
        
        (tutorialValidGroup, validGroup) = validGroupActions()
        
        invalidGroup        = invalidGroupAction()
        
        (dip, shrink)       = level8Actions()
        (wobble, stretch)   = level9Actions()
        (spin, expand)      = level10Actions()
        
    }
    
// MARK: Group of 3 PicSprites selected actions
    
    func validGroupActions() -> (SKAction, SKAction) {
        
        let grow = SKAction.resizeByWidth(10, height: 10, duration: 0.3)
        grow.timingMode = .EaseIn
        
        let playValidSound = SKAction.runBlock {
            if !Sounds.sharedInstance.validGroupSound.playing {
                Sounds.sharedInstance.validGroupSound.play()
            }
        }
        
        let disappear = SKAction.resizeByWidth(-80, height: -80, duration: 0.2)
        disappear.timingMode = .EaseOut
        
        let validGroupSequence = SKAction.sequence([grow, playValidSound, disappear, SKAction.removeFromParent()])
        
         return (SKAction.sequence([grow, grow.reversedAction()]), validGroupSequence)
        
    }
    
    func invalidGroupAction() -> SKAction {
        
        let moveRight = SKAction.moveByX(5.0, y: 0.0, duration: 0.025)
        let moveLeft = SKAction.moveByX(-5.0, y: 0.0, duration: 0.025)
        
        let wiggle = SKAction.sequence([moveLeft, moveLeft.reversedAction(), moveRight, moveRight.reversedAction()])
        
        let playInvalidSound = SKAction.runBlock {
            if !Sounds.sharedInstance.invalidGroupSound.playing {
                Sounds.sharedInstance.invalidGroupSound.play()
            }
        }
        
        return SKAction.sequence([playInvalidSound, SKAction.repeatAction(wiggle, count: 4)])
        
    }
    
// MARK: Actions for level 8-10
    
    func level8Actions() -> (SKAction, SKAction) {
        
        // Property 0: dip action
        
        let dipAction = SKAction.rotateByAngle(-CGFloat(M_PI / 8.0), duration: 0.1)
        let dipSequence = SKAction.sequence([dipAction, dipAction.reversedAction(),
            SKAction.waitForDuration(1.0)])
        
        // Property 1: shrink action
        
        let shrinkAction = SKAction.resizeByWidth(-10, height: -10, duration: 0.5)
        let shrinkSequence = SKAction.sequence([shrinkAction, shrinkAction.reversedAction(), SKAction.waitForDuration(0.5)])
        
        return (addWaitAndRepeat(dipSequence), addWaitAndRepeat(shrinkSequence))
    }
    
    func level9Actions() -> (SKAction, SKAction) {
        
        // Property 0: wobble action
        
        let wobbleRightAction = SKAction.rotateByAngle(-CGFloat(M_PI / 6.0), duration: 0.4)
        let wobbleLeftAction = SKAction.rotateByAngle(CGFloat(M_PI / 6.0), duration: 0.4)
        let wobbleSequence = SKAction.sequence([wobbleRightAction, wobbleRightAction.reversedAction(), wobbleLeftAction, wobbleLeftAction.reversedAction()])
        
        // Property 1: stretch action
        
        let stretchAction = SKAction.scaleXBy(1.2, y: 1.0, duration: 0.1)
        let stretchSequence = SKAction.sequence([stretchAction, stretchAction.reversedAction(),
            stretchAction, stretchAction.reversedAction(), SKAction.waitForDuration(1.0)])
        
        return (addWaitAndRepeat(wobbleSequence), addWaitAndRepeat(stretchSequence))
        
    }
    
    func level10Actions() -> (SKAction, SKAction) {
        
        // Property 0: spin action
        
        let spinAction = SKAction.rotateByAngle(CGFloat(M_PI), duration: 0.25)
        let spinSequence = SKAction.sequence([spinAction, SKAction.waitForDuration(1.0)])
        
        // Property 1: expand action
        
        let expandAction = SKAction.scaleBy(1.1, duration: 0.2)
        let expandSequence = SKAction.sequence([expandAction, expandAction.reversedAction(),
            SKAction.waitForDuration(1.0)])
        
        return (addWaitAndRepeat(spinSequence), addWaitAndRepeat(expandSequence))
    }
    
    func addWaitAndRepeat(action: SKAction) -> SKAction {
        return SKAction.sequence([wait, SKAction.repeatActionForever(action)])
    }
    
}
