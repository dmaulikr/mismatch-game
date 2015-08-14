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
import GameKit

class GameViewController: UIViewController {
    var level: Int!
    var scene: GameScene!
    var skView: SKView!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var groupsFoundLabel: UILabel!
    @IBOutlet weak var gameOverView: EndOfGameView!
    
    var runTimer: SKAction!
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
        
        skView.presentScene(scene)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let firstSprite = scene.grid.allPictures[0]
        if firstSprite.imageName != "level\(level)" + "-" + "\(firstSprite.imageNum)" {
            scene.grid.setLevel(level)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pauseGame", name: "pauseGame", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resumeGame", name: "resumeGame", object: nil)
        
        gameOverView.alpha = 0.0
        gameOverView.hidden = true
        
        scene.userInteractionEnabled = true
        scene.alpha = 1.0
        groupsFoundLabel.alpha = 1.0
        timerLabel.alpha = 1.0
        
        beginGame()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        Sounds.sharedInstance.backgroundMusic.stop()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        scene.removeActionForKey("runTimer")
        
        scene.removeSpritesFromScene(scene.grid.pictures)
        scene.selectedPics.removeAll(keepCapacity: true)
    }
    
    // Set up the game
    func beginGame() {
        
        scene.grid.selectInitialPictures()
        
        let pictures = scene.grid.pictures
        scene.addSpritesToScene(pictures)
        
        timerLabel.text = "2:00"
        counter = 120
        groupsFoundLabel.text = ""
        groupsFound = 0
        
        let timer = SKAction.waitForDuration(1.0)
        var callUpdateCounter = SKAction.runBlock {
            self.updateCounter()
        }
        
        runTimer = SKAction.repeatAction(SKAction.sequence([timer, callUpdateCounter]), count: counter)
        scene.runAction(runTimer, withKey: "runTimer")
        
    }
    
    // Decrement the counter every second; display alert after 2 minutes
    func updateCounter() {
        
        if counter == 120 {
            Sounds.sharedInstance.backgroundMusic.currentTime = 0
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
    
    /* Returns the previous high score */
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
        
        gameOverView.setEndOfGameText(groupsFound, prevHighScore: prevHighScore, level: level)
        gameOverView.setEndOfGameStars(groupsFound)
        gameOverView.hidden = false
        
        updateGameCenter()
        
        UIView.animateWithDuration(0.25, animations: {
            self.groupsFoundLabel.alpha = 0.5
            self.timerLabel.alpha = 0.5
            self.scene.alpha = 0.5
            self.gameOverView.alpha = 1.0
        })
    }
    
    func updateGameCenter() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var overallScore = 0
        if var highScoreArray = defaults.arrayForKey("highScores") as? [Int] {
            for highScore in highScoreArray {
                overallScore += highScore
            }
            overallScore -= highScoreArray[0]
        }
        
        let leaderboardID = "mismatch_leaderboard"
        var gkScore = GKScore(leaderboardIdentifier: leaderboardID)
        gkScore.value = Int64(overallScore)
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        GKScore.reportScores([gkScore], withCompletionHandler: { (error: NSError!) -> Void in
            if error != nil {
                println(error.localizedDescription)
            } else {
                println("New score submitted to game center")
            }
        })
    }
    
    func pauseGame() {
        println("pausing game")
        scene.removeActionForKey("runTimer")
        Sounds.sharedInstance.backgroundMusic.pause()
    }
    
    func resumeGame() {
        println("resuming game")
        scene.runAction(runTimer, withKey: "runTimer")
        Sounds.sharedInstance.backgroundMusic.play()
    }
    
}