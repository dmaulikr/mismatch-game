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

enum tags: Int {
    case levelLabel = 100
    case background = 101
    case highScoreLabel = 102
    case star1 = 201
    case star2 = 202
    case star3 = 203
}

let lightBlue = UIColor(red: 0, green: 128.0/255.0, blue: 1.0, alpha: 1.0)
let green = UIColor(red: 0, green: 163/255, blue: 0, alpha: 1.0)
let purple = UIColor(red: 128.0/255.0, green: 0, blue: 1.0, alpha: 1.0)
let darkBlue = UIColor(red: 0, green: 47.0/255.0, blue: 1.0, alpha: 1.0)
let orange = UIColor(red: 252.0/255.0, green: 92.0/255.0, blue: 10.0/255.0, alpha: 1.0)
let pink = UIColor(red: 223.0/255.0, green: 25.0/255.0, blue: 81.0/255.0, alpha: 1.0)

let oneStarScore = 10
let twoStarScore = 15
let threeStarScore = 20

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GKGameCenterControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var highScores: [Int] = [Int]()
    var unlockedLevels = 0
    
    let colors = [lightBlue, green, purple, pink, orange, darkBlue]
    
    var tutorialPageVC: PageDataSourceViewController?
    var gameVC: GameViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor.clearColor()
        let storyboard = self.storyboard
        tutorialPageVC = storyboard?.instantiateViewControllerWithIdentifier("PageDataSourceVC") as? PageDataSourceViewController
        gameVC = storyboard?.instantiateViewControllerWithIdentifier("GameViewController") as? GameViewController
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let scoresArray = defaults.arrayForKey("highScores") {
            highScores = scoresArray as! [Int]
            unlockedLevels = highScores.count - 1
            if highScores[unlockedLevels] >= 10 {
                unlockedLevels++
            }
        }
        
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LevelCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let view = cell.viewWithTag(tags.background.rawValue) as UIView!
        let levelLabel = cell.viewWithTag(tags.levelLabel.rawValue) as! UILabel
        let scoreLabel = cell.viewWithTag(tags.highScoreLabel.rawValue) as! UILabel
        
        let star1 = cell.viewWithTag(tags.star1.rawValue) as! UIImageView
        let star2 = cell.viewWithTag(tags.star2.rawValue) as! UIImageView
        let star3 = cell.viewWithTag(tags.star3.rawValue) as! UIImageView
        
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
    
    func formatStars(score: Int, stars: [UIImageView]) {
        
        switch score {
            
        case 0..<oneStarScore:
            stars[0].image = UIImage(named: "star-empty")
            stars[1].image = UIImage(named: "star-empty")
            stars[2].image = UIImage(named: "star-empty")
            
        case oneStarScore..<twoStarScore:
            stars[0].image = UIImage(named: "star")
            stars[1].image = UIImage(named: "star-empty")
            stars[2].image = UIImage(named: "star-empty")
            
        case twoStarScore..<threeStarScore:
            stars[0].image = UIImage(named: "star")
            stars[1].image = UIImage(named: "star")
            stars[2].image = UIImage(named: "star-empty")
            
        default:
            stars[0].image = UIImage(named: "star")
            stars[1].image = UIImage(named: "star")
            stars[2].image = UIImage(named: "star")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            
            self.presentViewController(tutorialPageVC!, animated: true, completion: nil)
            
        } else if indexPath.row <= unlockedLevels {
            
            gameVC!.level = indexPath.row
            self.presentViewController(gameVC!, animated: true, completion: nil)
            
            // performSegueWithIdentifier("LevelSegue", sender: self)
            
        }
    }
    
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
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func showLeaderboard() {
        var gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        gcViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        gcViewController.leaderboardIdentifier = "mismatch-leaderboard"
        
        self.presentViewController(gcViewController, animated: true, completion: nil)
        
    }
    
}
