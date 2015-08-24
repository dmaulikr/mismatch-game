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

let GameLengthInSeconds = 120

class GameViewController: UIViewController {
    
    var level: Int!
    var scene: GameScene!
    var skView: SKView!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var groupsFoundLabel: UILabel!
    @IBOutlet weak var gameOverAlert: EndOfGameView!
    
    var runTimer: SKAction!
    var counter: Int = GameLengthInSeconds
    var groupsFound: Int = 0
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.tapThreeHandler = handleTapThree
        scene.grid = Grid(level: level, layer: scene.picturesLayer)
        
        gameOverAlert.layer.cornerRadius = 10.0
        gameOverAlert.layer.borderColor = LightBlue.CGColor
        gameOverAlert.layer.borderWidth = 1.0
        
        skView.presentScene(scene)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        scene.grid.setLevel(level) 
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pauseGame", name: "pauseGame", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resumeGame", name: "resumeGame", object: nil)
        
        gameOverAlert.alpha = 0.0
        gameOverAlert.hidden = true
        
        scene.userInteractionEnabled = true
        scene.alpha = 1.0
        groupsFoundLabel.alpha = 1.0
        timerLabel.alpha = 1.0
        
        beginGame()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        Sounds.sharedInstance.backgroundMusic.currentTime = 0
        Sounds.sharedInstance.backgroundMusic.play()
        
    }
    
// MARK: - Start of game
    
    func beginGame() {
        
        scene.grid.selectInitialPictures(level)
        
        let pictures = scene.grid.pictures
        scene.addSpritesToScene(pictures)
        
        timerLabel.text = "2:00"
        counter = 120
        
        groupsFoundLabel.text = ""
        groupsFound = 0
        
        let timer = SKAction.waitForDuration(1.0)
        var updateCounterAction = SKAction.runBlock {
            self.updateCounter()
        }
        
        runTimer = SKAction.repeatAction(SKAction.sequence([timer, updateCounterAction]), count: counter)
        scene.runAction(runTimer, withKey: "runTimer")
        
    }
    
// MARK: - During game
    
    // Decrement the counter every second; display alert after 2 minutes
    func updateCounter() {
        
        counter--
        let minutes = counter / 60
        let seconds = counter % 60
        timerLabel.text = String(format: "%01d:%02d", arguments: [minutes, seconds])
        
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
        
        println("Selected: \(group.description)")
        
        if group.isValid() {
            println(" - Valid group - ")
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
            println(" - Invalid group - ")
            group.pictureA.runInvalidGroupAction()
            group.pictureB.runInvalidGroupAction()
            group.pictureC.runInvalidGroupAction()
            scene.selectedPics.removeAll()
            self.view.userInteractionEnabled = true
        }
    }
    
    // Increment number of groups found
    func updateGroupsFoundLabel() {
        groupsFound++
        groupsFoundLabel.text = String(groupsFound)
    }

// MARK: - End of game
    
    // Display alert when two minutes have passed
    func presentEndOfGameAlert(prevHighScore: Int) {
        
        view.userInteractionEnabled = true
        
        gameOverAlert.setEndOfGameText(groupsFound, prevHighScore: prevHighScore, level: level)
        gameOverAlert.setEndOfGameStars(groupsFound)
        gameOverAlert.hidden = false
        
        updateGameCenter()
        
        UIView.animateWithDuration(0.25, animations: {
            self.groupsFoundLabel.alpha = 0.5
            self.timerLabel.alpha = 0.5
            self.scene.alpha = 0.5
            self.gameOverAlert.alpha = 1.0
        })
    }
    
    /* Returns the previous high score */
    func updateHighScore() -> Int {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var prevHighScore = 0
        
        if var highScoreArray = defaults.arrayForKey("highScores") as? [Int] {
            
            
            
            if highScoreArray.count < level+1 {
                
                // No high score for current level yet, so add it to array
                highScoreArray += [groupsFound]
                
            } else {
                
                // Get previous high score, keeps whichever is greater
                
                prevHighScore = highScoreArray[level]
                highScoreArray[level] = prevHighScore >= groupsFound ? prevHighScore : groupsFound
            }
            
            defaults.setObject(highScoreArray, forKey: "highScores")
        }
        return prevHighScore
    }
    
    func updateGameCenter() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var overallScore = 0
        
        if var highScoreArray = defaults.arrayForKey("highScores") as? [Int] {
            for highScore in highScoreArray {
                overallScore += highScore
            }
            overallScore -= highScoreArray[0] // Subtract tutorial level score
        }
        
        // let leaderboardID = "mismatch_game_leaderboard"
        
        let leaderboardID = "mismatch_level_\(level)"
        
        var gkScore = GKScore(leaderboardIdentifier: leaderboardID)
        // gkScore.value = Int64(overallScore)
        gkScore.value = Int64(groupsFound)
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        GKScore.reportScores([gkScore], withCompletionHandler: { (error: NSError!) -> Void in
            if error != nil {
                println(error.localizedDescription)
            } else {
                println("New score submitted to game center")
            }
        })
    }
    
// MARK: - Pause and resume
    
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
    
// MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        Sounds.sharedInstance.backgroundMusic.stop()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        scene.removeActionForKey("runTimer")
        
        scene.removeSpritesFromScene(scene.grid.pictures)
        scene.selectedPics.removeAll(keepCapacity: true)
    }
    
}