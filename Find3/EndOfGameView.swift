//
//  EndOfGameView.swift
//  Find3
//
//  Created by Susan Stevens on 6/26/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import UIKit

/// Subclass of UIView presented at end of each game
class EndOfGameView: UIView {

    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    
    @IBOutlet weak var gameOverTitle: UILabel!
    @IBOutlet weak var gameOverMsg: UILabel!
    
    var titles: [String] = []
    
    /// Set text to be displayed at end of game
    func setEndOfGameText(groupsFound: Int, prevHighScore: Int, level: Int) {
        
        let unit = groupsFound == 1 ? "(mis)match" : "(mis)matches"
        
        if groupsFound >= OneStarScore && prevHighScore < OneStarScore && level != 10 {
            
            gameOverTitle.text = "Congrats!"
            gameOverMsg.text! += "You found \(groupsFound) (mis)matches and unlocked the next level."
            
        } else if groupsFound > prevHighScore {
            
            gameOverTitle.text = "New high score!"
            gameOverMsg.text! += "You found \(groupsFound) " + unit + "."
            
        } else {
            
            gameOverTitle.text = randomTitle(groupsFound)
            gameOverMsg.text = "You found \(groupsFound) " + unit + "."
            
            if prevHighScore < OneStarScore && level != 10 {
                gameOverMsg.text! += " You need at least \(OneStarScore) to unlock the next level."
            }
            
        }
    }
    
    /// Fill correct stars at end of game
    func setEndOfGameStars(groupsFound: Int) {
        starOne.image = UIImage(named: "star-empty")
        starTwo.image = UIImage(named: "star-empty")
        starThree.image = UIImage(named: "star-empty")
        
        if groupsFound >= OneStarScore {
            starOne.image = UIImage(named: "star")
        }
        
        if groupsFound >= TwoStarScore {
            starTwo.image = UIImage(named: "star")
        }
        
        if groupsFound >= ThreeStarScore {
            starThree.image = UIImage(named: "star")
        }
    }
    
    /// Returns a random end-of-game message appropriate for number of (mis)matches found
    func randomTitle(groupsFound: Int) -> String {
        
        switch groupsFound {
        case 0..<OneStarScore:
            titles = ["Time's up!"]
        case OneStarScore..<TwoStarScore:
            titles = ["Awesome!", "Terrific!", "Super!"]
        case TwoStarScore..<ThreeStarScore:
            titles = ["Amazing!", "Impressive!", "Fantastic!"]
        default:
            titles = ["Remarkable!", "Outstanding!", "Astonishing!"] 
        }
        
        return titles[Int(arc4random_uniform(UInt32(titles.count)))]
    }
}
