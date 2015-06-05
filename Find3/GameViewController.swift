//
//  GameViewController.swift
//  Find3
//
//  Created by Susan Stevens on 5/11/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var level: String!
    var scene: GameScene!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var groupsFoundLabel: UILabel!
    
    var timer: SKAction!
    var counter: Int = 120
    var groupsFound: Int = 0
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.multipleTouchEnabled = false

        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.tapThreeHandler = handleTapThree
        scene.grid = Grid(level: level, layer: scene.picturesLayer)
        
        skView.presentScene(scene)
        
        beginGame()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindToHomeSegue" || segue.identifier == "unwindToHomeFromButton" {
            println("remove scene from parent")
            
            scene.removeActionForKey("runTimer")
            scene.removeActionForKey("runRemovePicTimer")
            
            for picture in scene.grid.allPictures {
                picture.removeFromParent()
            }
            
            let gameLayer = scene.childNodeWithName("Game Layer")
            let pictureLayer = gameLayer?.childNodeWithName("Pictures Layer")
            
            for picture in scene.grid.allPictures {
                picture.removeFromParent()
            }
            
            pictureLayer?.removeFromParent()
            gameLayer?.removeFromParent()
            scene.removeFromParent()
            
        }
    }
    
    // Set up the game
    func beginGame() {
        let pictures = scene.grid.pictures
        scene.addSpritesForPictures(pictures)
        
        timerLabel.text = "2:00"
        counter = 120
        groupsFoundLabel.text = ""
        groupsFound = 0
        
        timer = SKAction.waitForDuration(1.0)
        var callUpdateCounter = SKAction.runBlock {
            self.updateCounter()
        }
        let runTimer = SKAction.repeatAction(SKAction.sequence([timer, callUpdateCounter]), count: counter)
        
        self.scene.runAction(runTimer, withKey: "runTimer")
        
        if level == "level5" {
            let removePicTimer = SKAction.waitForDuration(4.0, withRange: 3.0)
            let callRemoveAtRandom = SKAction.runBlock {
                self.removeAtRandom()
            }
            
            let runRemovePicTimer = SKAction.repeatActionForever(SKAction.sequence([removePicTimer, callRemoveAtRandom]))
            
            self.scene.runAction(runRemovePicTimer, withKey: "runRemovePicTimer")
        }
    }
    
    // Decrement the counter after each second passes; display alert after 2 minutes
    func updateCounter() {
        counter--
        let minute = counter / 60
        let seconds = counter % 60
        timerLabel.text = String(format: "%01d:%02d", arguments: [minute, seconds])
        if counter == 0 {
            self.view.userInteractionEnabled = false
            self.scene.removeActionForKey("runRemovePicTimer")
            presentEndOfGameAlert()
        }
    }
    
    // Used in Level 5 to select a random PicSprite to remove
    func removeAtRandom() {
        let col = Int(arc4random_uniform(3))
        let row = Int(arc4random_uniform(3))
        
        scene.removePicAtColumn(col, row: row) {
            
            let columns = self.scene.grid.fillHoles()
            
            println("Columns: \(columns.count)")
            self.scene.animateFallingPictures(columns) {
                let columns = self.scene.grid.addMorePictures()
                self.scene.animateNewPictures(columns) {
                    
                }
            }
        }
    }
    
    // Called when user has selected 3 sprites
    func handleTapThree(group: PictureGroup) {
        self.view.userInteractionEnabled = false
        
        println(group.description)
        
        if group.isValidGroup() {
            println("valid group")
            updateGroupsFoundLabel()
            scene.grid.removePictures(group)
            scene.animateValidGroup(group) {
                let columns = self.scene.grid.fillHoles()
                self.scene.animateFallingPictures(columns) {
                    let columns = self.scene.grid.addMorePictures()
                    self.scene.animateNewPictures(columns) {
                        self.view.userInteractionEnabled = true
                    }
                }
            }
        } else {
            println("invalid group")
            group.pictureA.wiggleAndDeselect()
            group.pictureB.wiggleAndDeselect()
            group.pictureC.wiggleAndDeselect()
            scene.selectedPics.removeAll()
            self.view.userInteractionEnabled = true
        }
    }
    
    // Increment number of groups found
    func updateGroupsFoundLabel() {
        groupsFound++
        groupsFoundLabel.text = String(groupsFound)
    }
    
    // Display alert when two minutes have passed
    func presentEndOfGameAlert() {
        let alertController = UIAlertController(title: "Good game!", message: "You found \(groupsFound) groups", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            println("OK pressed")
            self.performSegueWithIdentifier("unwindToHomeSegue", sender: self)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            println("presenting alert controller")
        }
    }

}