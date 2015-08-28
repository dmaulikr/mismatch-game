//
//  HomeViewController.swift
//  Find3
//
//  Created by Susan Stevens on 5/16/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import UIKit
import QuartzCore
import GameKit

enum Tags: Int {
    case LevelLabel     = 100
    case Background     = 101
    case HighScoreLabel = 102
    case Star1          = 201
    case Star2          = 202
    case Star3          = 203
}

let LightBlue   = UIColor(red: 0, green: 128.0/255.0, blue: 1.0, alpha: 1.0)
let Green       = UIColor(red: 0, green: 163/255, blue: 0, alpha: 1.0)
let Purple      = UIColor(red: 128.0/255.0, green: 0, blue: 1.0, alpha: 1.0)
let Pink        = UIColor(red: 223.0/255.0, green: 25.0/255.0, blue: 81.0/255.0, alpha: 1.0)
let Orange      = UIColor(red: 252.0/255.0, green: 92.0/255.0, blue: 10.0/255.0, alpha: 1.0)
let DarkBlue    = UIColor(red: 0, green: 47.0/255.0, blue: 1.0, alpha: 1.0)

let OneStarScore    = 10
let TwoStarScore    = 15
let ThreeStarScore  = 20

let NumLevels = 11

class HomeViewController: UIViewController, UITableViewDataSource,
                            UITableViewDelegate, GKGameCenterControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var highScores: [Int] = [Int]()
    var unlockedLevels = 0
    
    let colors = [LightBlue, Green, Purple, Pink, Orange, DarkBlue]
    
    var tutorialPageVC: PageDataSourceViewController?
    var gameVC: GameViewController?
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor.clearColor()
        
        let storyboard = self.storyboard
        
        tutorialPageVC = storyboard?.instantiateViewControllerWithIdentifier("PageDataSourceVC")
            as? PageDataSourceViewController
        
        gameVC = storyboard?.instantiateViewControllerWithIdentifier("GameViewController")
            as? GameViewController
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(false)
        
        let defaults = NSUserDefaults.standardUserDefaults()

        if let scoresArray = defaults.arrayForKey("highScores") {
            
            highScores = scoresArray as! [Int]
            
            unlockedLevels = highScores.count - 1 // Subtract one for tutorial
            
            if highScores[unlockedLevels] >= 10 {
                unlockedLevels++ // Unlock additional level if last high score is greater than 10
            }
        }
        
        tableView.reloadData()
    }
    
    
// MARK: - TableView data source methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NumLevels
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LevelCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let view = cell.viewWithTag(Tags.Background.rawValue) as UIView!
        let levelLabel = cell.viewWithTag(Tags.LevelLabel.rawValue) as! UILabel
        let scoreLabel = cell.viewWithTag(Tags.HighScoreLabel.rawValue) as! UILabel
        
        let star1 = cell.viewWithTag(Tags.Star1.rawValue) as! UIImageView
        let star2 = cell.viewWithTag(Tags.Star2.rawValue) as! UIImageView
        let star3 = cell.viewWithTag(Tags.Star3.rawValue) as! UIImageView
        
        view.layer.borderColor = colors[indexPath.row % 6].CGColor
        view.layer.borderWidth = 6.0
        
        
        if indexPath.row == 0 {
            
            // Tutorial Level
            
            view.alpha = 1.0
            levelLabel.text = "Tutorial"
            
            star1.hidden = true
            star2.hidden = true
            star3.hidden = true
            
            scoreLabel.text = ""
            
        } else if indexPath.row + 1 <= highScores.count {
            
            // Levels that have been played
            
            view.alpha = 1.0
            levelLabel.text = "Level \(indexPath.row)"
            
            star1.hidden = false
            star2.hidden = false
            star3.hidden = false
            
            formatStars(highScores[indexPath.row], stars: [star1, star2, star3])
            
            scoreLabel.text = "High Score: \(highScores[indexPath.row])"
            
        } else {
            
            // Levels that have NOT been played
            
            view.alpha = indexPath.row > unlockedLevels ? 0.5 : 1.0
            
            levelLabel.text = "Level \(indexPath.row)"
            
            star1.hidden = true
            star2.hidden = true
            star3.hidden = true
            
            scoreLabel.text = ""
        }
        
        return cell
    }
    
    /// Display stars for each level on homepage
    func formatStars(score: Int, stars: [UIImageView]) {
        
        switch score {
            
        case 0..<OneStarScore:
            stars[0].image = UIImage(named: "star-empty")
            stars[1].image = UIImage(named: "star-empty")
            stars[2].image = UIImage(named: "star-empty")
            
        case OneStarScore..<TwoStarScore:
            stars[0].image = UIImage(named: "star")
            stars[1].image = UIImage(named: "star-empty")
            stars[2].image = UIImage(named: "star-empty")
            
        case TwoStarScore..<ThreeStarScore:
            stars[0].image = UIImage(named: "star")
            stars[1].image = UIImage(named: "star")
            stars[2].image = UIImage(named: "star-empty")
            
        default:
            stars[0].image = UIImage(named: "star")
            stars[1].image = UIImage(named: "star")
            stars[2].image = UIImage(named: "star")
        }
    }

// MARK: - TableView delegate methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            
            self.presentViewController(tutorialPageVC!, animated: true, completion: nil)
            
        } else if indexPath.row <= unlockedLevels {
            
            gameVC!.level = indexPath.row
            self.presentViewController(gameVC!, animated: true, completion: nil)
            
            // performSegueWithIdentifier("LevelSegue", sender: self)
            
        }
    }
    
// MARK: - Game Center (Leaderboard)
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func showLeaderboard() {
        var gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        gcViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        // gcViewController.leaderboardIdentifier = "mismatch_combined_leaderboard"
        
        self.presentViewController(gcViewController, animated: true, completion: nil)
        
    }
    
// MARK: - Navigation
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        println("unwind to home")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LevelSegue" {
            if let gameVC = segue.destinationViewController as? GameViewController {
                if let index = tableView.indexPathForSelectedRow()?.row {
                    gameVC.level = index
                }
            }
        }
    }
    
}
