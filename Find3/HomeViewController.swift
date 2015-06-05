//
//  HomeViewController.swift
//  Find3
//
//  Created by Susan Stevens on 5/16/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        println("unwind to home")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Level1Segue" {
            if let gameVC = segue.destinationViewController as? GameViewController {
                    gameVC.level = "level1"
            }
        } else if segue.identifier == "Level2Segue" {
            if let gameVC = segue.destinationViewController as? GameViewController {
                gameVC.level = "level2"
            }
        } else if segue.identifier == "Level3Segue" {
            if let gameVC = segue.destinationViewController as? GameViewController {
                gameVC.level = "level3"
            }
        } else if segue.identifier == "Level4Segue" {
            if let gameVC = segue.destinationViewController as? GameViewController {
                gameVC.level = "level4"
            }
        } else if segue.identifier == "Level5Segue" {
            if let gameVC = segue.destinationViewController as? GameViewController {
                gameVC.level = "level5"
            }
        } else if segue.identifier == "TutorialSegue" {
            if let tutorialVC = segue.destinationViewController as? PageDataSourceViewController {
                tutorialVC.level = "tutorial"
            }
        }
    }
}
