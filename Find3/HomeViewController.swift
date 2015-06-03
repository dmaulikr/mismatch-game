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
    
    override func viewDidLoad() {
        let leftConstraint = NSLayoutConstraint(item: self.contentView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self.contentView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: 0)
        
        self.view.addConstraint(leftConstraint)
        self.view.addConstraint(rightConstraint)
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
        }
    }
}
