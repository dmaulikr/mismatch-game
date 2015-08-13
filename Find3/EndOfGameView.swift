//
//  EndOfGameView.swift
//  Find3
//
//  Created by Susan Stevens on 6/26/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import UIKit

class EndOfGameView: UIView {

    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    
    @IBOutlet weak var gameOverTitle: UILabel!
    @IBOutlet weak var gameOverMsg: UILabel!
    
    var titles: [String] = []
    
    func setEndOfGameText(groupsFound: Int, prevHighScore: Int) {
        
        if groupsFound >= oneStarScore && prevHighScore < oneStarScore {
            gameOverTitle.text = "Congrats!"
            gameOverMsg.text = "You found \(groupsFound) (mis)matches and unlocked the next level."
        } else if groupsFound > prevHighScore {
            gameOverTitle.text = "New High Score!"
            gameOverMsg.text = "You found \(groupsFound) (mis)matches."
        } else {
            gameOverTitle.text = generateTitle(groupsFound)
            gameOverMsg.text = "You found \(groupsFound) (mis)matches."
            
            if prevHighScore < oneStarScore {
                gameOverMsg.text! += " You need at least \(oneStarScore) to unlock the next level."
            }
        }
    }
    
    func setEndOfGameStars(groupsFound: Int) {
        starOne.image = UIImage(named: "star-empty")
        starTwo.image = UIImage(named: "star-empty")
        starThree.image = UIImage(named: "star-empty")
        
        if groupsFound >= oneStarScore {
            starOne.image = UIImage(named: "star")
        }
        
        if groupsFound >= twoStarScore {
            starTwo.image = UIImage(named: "star")
        }
        
        if groupsFound >= threeStarScore {
            starThree.image = UIImage(named: "star")
        }
    }
    
    func generateTitle(groupsFound: Int) -> String {
        
        switch groupsFound {
        case 0:
            titles = ["Better luck next time!"]
        case 1..<oneStarScore:
            titles = ["Not bad!", "A-okay!", "Nice!"]
        case oneStarScore..<twoStarScore:
            titles = ["Awesome!", "High five!", "Thumbs up!"]
        case twoStarScore..<threeStarScore:
            titles = ["Amazing!", "Stellar!", "Superb!"]
        default:
            titles = ["Remarkable!", "Outstanding!", "Astonishing!"]
        }
        
        return titles[Int(arc4random_uniform(UInt32(titles.count)))]
    }
}
