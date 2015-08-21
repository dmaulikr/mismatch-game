//
//  LastTutorialViewController.swift
//  Find3
//
//  Created by Susan Stevens on 6/19/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import UIKit

class LastTutorialViewController: UIViewController {
    
// MARK: - Navigation

    @IBAction func startButtonTapped(sender: AnyObject) {
        
        performSegueWithIdentifier("Level1Segue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Level1Segue" {
            if let gameVC = segue.destinationViewController as? GameViewController {
                gameVC.level = 1
            }
        }
    }
}
