//
//  GameViewController.swift
//  Find3
//
//  Created by Susan Stevens on 5/11/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit

class GameViewController: UIViewController {
    var level: Int!
    var scene: GameScene!
    var skView: SKView!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var groupsFoundLabel: UILabel!
    @IBOutlet weak var gameOverView: EndOfGameView!
    
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
        
        skView = view as! SKView
        skView.multipleTouchEnabled = false
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.tapThreeHandler = handleTapThree
        scene.grid = Grid(level: level, layer: scene.picturesLayer)
        
        gameOverView.layer.cornerRadius = 10.0
        gameOverView.layer.borderColor = lightBlue.CGColor
        gameOverView.layer.borderWidth = 1.0
        gameOverView.alpha = 0.0
        gameOverView.hidden = true
        
        skView.presentScene(scene)
        
        beginGame()
    }
    
    override func viewDidDisappear(animated: Bool) {
        skView.presentScene(nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        Sounds.sharedInstance.backgroundMusic.stop()
        
        if segue.identifier == "unwindToHomeSegue" || segue.identifier == "unwindToHomeFromButton" {
            println("remove scene from parent")
            
            scene.removeActionForKey("runTimer")
            scene.removeActionForKey("runRemovePicTimer")
            
            for picture in scene.grid.allPictures {
                picture.removeFromParent()
            }
            
            scene.grid.allPictures.removeAll()
            scene.grid.validGroups.removeAll()
            scene.selectedPics.removeAll()
            
            for row in 0..<3 {
                for col in 0..<3 {
                    scene.grid.pictures[col, row] = nil
                }
            }
            
            let gameLayer = scene.childNodeWithName("Game Layer")
            let pictureLayer = gameLayer?.childNodeWithName("Pictures Layer")
            
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
        
        scene.runAction(runTimer, withKey: "runTimer")
        
        if level == 10 {
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
        
        if counter == 120 {
            Sounds.sharedInstance.backgroundMusic.play()
        }
        
        counter--
        let minute = counter / 60
        let seconds = counter % 60
        timerLabel.text = String(format: "%01d:%02d", arguments: [minute, seconds])
        
        if counter == 0 {
            self.scene.userInteractionEnabled = false
            self.scene.removeActionForKey("runRemovePicTimer")
            let prevHighScore = updateHighScore()
            presentEndOfGameAlert(prevHighScore)
        }
    }
    
    // Used in Level 5 to select a random PicSprite to remove
    func removeAtRandom() {
        let col = Int(arc4random_uniform(3))
        let row = Int(arc4random_uniform(3))
        
        scene.removePicAtColumn(col, row: row) {
            
            let columns = self.scene.grid.fillHoles()
            
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
    
    /* Returns two bools - first indicates if new high score, second indicates if next level unlocked */
    func updateHighScore() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        var prevHighScore = 0
        if var highScoreArray = defaults.arrayForKey("highScores") as? [Int] {
            
            if highScoreArray.count < level+1 {
                highScoreArray += [groupsFound]
            } else {
                prevHighScore = highScoreArray[level]
                highScoreArray[level] = prevHighScore >= groupsFound ? prevHighScore : groupsFound
            }
            
            defaults.setObject(highScoreArray, forKey: "highScores")
        }
        return prevHighScore
    }
    
    // Display alert when two minutes have passed
    func presentEndOfGameAlert(prevHighScore: Int) {
        
        view.userInteractionEnabled = true
        
        gameOverView.setEndOfGameText(groupsFound, prevHighScore: prevHighScore)
        gameOverView.setEndOfGameStars(groupsFound)
        gameOverView.hidden = false
        
        UIView.animateWithDuration(0.25, animations: {
            self.groupsFoundLabel.alpha = 0.5
            self.timerLabel.alpha = 0.5
            self.scene.alpha = 0.5
            self.gameOverView.alpha = 1.0
        })
    }
    
}