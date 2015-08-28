//
//  TutorialScene.swift
//  Find3
//
//  Created by Susan Stevens on 6/4/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import SpriteKit

/// Subclass of GameScene used in tutorial. Overrides animation for valid group selection.
class TutorialScene: GameScene {
    
    /// Perform animation when user selects a valid group
    override func animateValidGroup(group: PictureGroup, completion: () -> ()) {
        
        let expandAction = SKAction.runBlock {
            group.pictureA.runTutorialValidGroupAction()
            group.pictureB.runTutorialValidGroupAction()
            group.pictureC.runTutorialValidGroupAction()
        }
        
        runAction(SKAction.sequence([expandAction, SKAction.waitForDuration(1.0)]), completion: completion)
    }
    
}
