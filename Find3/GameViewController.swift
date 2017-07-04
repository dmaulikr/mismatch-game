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
    @IBOutlet weak var pausedOverlay: UIVisualEffectView!
    
    var runTimer: SKAction!
    var counter: Int = GameLengthInSeconds
    var groupsFound: Int = 0
    var musicCurrentTime: TimeInterval = 0.0
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.tapThreeHandler = handleTapThree
        scene.grid = Grid(level: level, layer: scene.picturesLayer)
        
        gameOverAlert.layer.cornerRadius = 10.0
        gameOverAlert.layer.borderColor = LightBlue.cgColor
        gameOverAlert.layer.borderWidth = 1.0
        
        skView.presentScene(scene)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        scene.grid.setLevel(level) 
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.pauseGame), name: NSNotification.Name(rawValue: "pauseGame"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.resumeGame), name: NSNotification.Name(rawValue: "resumeGame"), object: nil)
        
        gameOverAlert.alpha = 0.0
        gameOverAlert.isHidden = true
        
        scene.isUserInteractionEnabled = true
        scene.alpha = 1.0
        groupsFoundLabel.alpha = 1.0
        timerLabel.alpha = 1.0
        pausedOverlay.isHidden = true
        
        beginGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        Sounds.sharedInstance.backgroundMusic.currentTime = 0
        Sounds.sharedInstance.backgroundMusic.play()
        
    }
    
// MARK: - Start of game
    
    /// Set up sprites, timers and labels for beginning of game
    func beginGame() {
        
        scene.isPaused = false
        scene.grid.selectInitialPictures(level)
        
        let pictures = scene.grid.pictures
        scene.addSpritesToScene(pictures)
        
        timerLabel.text = "2:00"
        counter = 120
        
        groupsFoundLabel.text = ""
        groupsFound = 0
        
        let timer = SKAction.wait(forDuration: 1.0)
        let updateCounterAction = SKAction.run {
            self.updateCounter()
        }
        
        runTimer = SKAction.repeat(SKAction.sequence([timer, updateCounterAction]), count: counter)
        scene.run(runTimer, withKey: "runTimer")
        
    }
    
// MARK: - During game
    
    /// Decrement the counter every second; display end-of-game alert after 2 minutes
    func updateCounter() {
        
        counter -= 1
        let minutes = counter / 60
        let seconds = counter % 60
        timerLabel.text = String(format: "%01d:%02d", arguments: [minutes, seconds])
        
        if counter == 0 {
            
            self.scene.isUserInteractionEnabled = false
            self.scene.removeAction(forKey: "runTimer")
            
            let prevHighScore = updateHighScore()
            presentEndOfGameAlert(prevHighScore)
            
        }
    }
    
    /// Called when user has selected 3 sprites
    func handleTapThree(_ group: PictureGroup) {
        self.view.isUserInteractionEnabled = false
        
        print("Selected: \(group.description)")
        
        if group.isValid() {
            print(" - Valid group - ")
            updateGroupsFoundLabel()
            scene.grid.removePictures(group)
            
            scene.animateValidGroup(group) {
                let columns = self.scene.grid.fillHoles()
                self.scene.animateFallingPictures(columns) {
                    let columns = self.scene.grid.addMorePictures()
                    self.scene.animateNewPictures(columns) {
                        self.view.isUserInteractionEnabled = true
                    }
                }
            }
        } else {
            print(" - Invalid group - ")
            group.pictureA.runInvalidGroupAction()
            group.pictureB.runInvalidGroupAction()
            group.pictureC.runInvalidGroupAction()
            scene.selectedPics.removeAll()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    /// Increment number of groups found
    func updateGroupsFoundLabel() {
        groupsFound += 1
        groupsFoundLabel.text = String(groupsFound)
    }

// MARK: - End of game
    
    /// Display alert when two minutes have passed
    func presentEndOfGameAlert(_ prevHighScore: Int) {
        
        view.isUserInteractionEnabled = true
        
        gameOverAlert.setEndOfGameText(groupsFound, prevHighScore: prevHighScore, level: level)
        gameOverAlert.setEndOfGameStars(groupsFound)
        gameOverAlert.isHidden = false
        
        updateGameCenter()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.groupsFoundLabel.alpha = 0.5
            self.timerLabel.alpha = 0.5
            self.scene.alpha = 0.5
            self.gameOverAlert.alpha = 1.0
        })
    }
    
    /// Updates high score in NSUserDefaults and returns previous high score for current level
    func updateHighScore() -> Int {
        
        let defaults = UserDefaults.standard
        var prevHighScore = 0
        
        if var highScoreArray = defaults.array(forKey: "highScores") as? [Int] {
            
            
            
            if highScoreArray.count < level+1 {
                
                // No high score for current level yet, so add it to array
                highScoreArray += [groupsFound]
                
            } else {
                
                // Get previous high score, keeps whichever is greater
                
                prevHighScore = highScoreArray[level]
                highScoreArray[level] = prevHighScore >= groupsFound ? prevHighScore : groupsFound
            }
            
            defaults.set(highScoreArray, forKey: "highScores")
        }
        return prevHighScore
    }
    
    /// Sends new score to Game Center
    func updateGameCenter() {
        
        let leaderboardID = "mismatch_level_\(level)"
        
        let gkScore = GKScore(leaderboardIdentifier: leaderboardID)
        gkScore.value = Int64(groupsFound)
        
        // let localPlayer = GKLocalPlayer.localPlayer()
        
        GKScore.report([gkScore], withCompletionHandler: { (error: Error?) -> Void in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("New score submitted to game center")
            }
        })
    }
    
// MARK: - Pause and resume
    
    /// Pause timer and background music
    func pauseGame() {
        scene.isPaused = true
        Sounds.sharedInstance.backgroundMusic.pause()
        musicCurrentTime = Sounds.sharedInstance.backgroundMusic.currentTime
    }
    
    /// Restart timer and background music
    func resumeGame() {
        scene.isPaused = false
        Sounds.sharedInstance.backgroundMusic.currentTime = musicCurrentTime
        Sounds.sharedInstance.backgroundMusic.play()
    }
    
    @IBAction func didTapPauseButton(_ sender: Any) {
        pauseGame()
        pausedOverlay.isHidden = false
        UIView.animate(withDuration: 0.1, animations: {
            self.pausedOverlay.alpha = 1.0
        })
    }
    
    @IBAction func didTapResumeButton(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.pausedOverlay.alpha = 0
        }, completion: { _ in
            self.pausedOverlay.isHidden = true
            self.resumeGame()
        })
    }
    
// MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Sounds.sharedInstance.backgroundMusic.stop()
        
        NotificationCenter.default.removeObserver(self)
        scene.removeAction(forKey: "runTimer")
        
        scene.removeSpritesFromScene(scene.grid.pictures)
        scene.selectedPics.removeAll(keepingCapacity: true)
    }
    
}
