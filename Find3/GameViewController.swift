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
    
    var timer = NSTimer()
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
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        
        
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
            
            let gameLayer = scene.childNodeWithName("Game Layer")
            let pictureLayer = gameLayer?.childNodeWithName("Pictures Layer")
            
            for picture in scene.grid.allPictures {
                picture.removeFromParent()
            }
            
            pictureLayer?.removeFromParent()
            gameLayer?.removeFromParent()
            scene.removeFromParent()
            
            self.timer.invalidate()
        }
    }
    
    func beginGame() {
        let pictures = scene.grid.pictures
        scene.addSpritesForPictures(pictures)
        
        timerLabel.text = "2:00"
        counter = 120
        groupsFoundLabel.text = ""
        groupsFound = 0
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
    }
    
    func updateCounter() {
        counter--
        let minute = counter / 60
        let seconds = counter % 60
        timerLabel.text = String(format: "%01d:%02d", arguments: [minute, seconds])
        if counter == 0 {
            timer.invalidate()
            self.view.userInteractionEnabled = false
            presentEndOfGameAlert()
            saveScoreToCloud()
        }
    }
    
    func handleTapThree(group: PictureGroup) {
        self.view.userInteractionEnabled = false
        
        println(group.description)
        
        // if scene.grid.validGroups.contains(group) {
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
    
    func updateGroupsFoundLabel() {
        groupsFound++
        groupsFoundLabel.text = String(groupsFound)
    }
    
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
    
    func saveScoreToCloud() {
        let score = HighScore(score: groupsFound, date: NSDate())
        CloudKitManager.sharedInstance.addHighScore(score)
    }

}