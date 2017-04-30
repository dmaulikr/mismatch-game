//
//  LastTutorialViewController.swift
//  Find3
//
//  Created by Susan Stevens on 6/19/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import UIKit

/// Final page of tutorial; appears after user finds one (mis)match
class LastTutorialViewController: UIViewController {
    
// MARK: - Navigation

    @IBAction func startButtonTapped(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "Level1Segue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Level1Segue" {
            if let gameVC = segue.destination as? GameViewController {
                gameVC.level = 1
            }
        }
    }
}
