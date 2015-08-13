//
//  TutorialViewController.swift
//  Find3
//
//  Created by Susan Stevens on 6/11/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import Foundation
import SpriteKit

class TutorialViewController: UIViewController {
    
    
    @IBOutlet weak var needHintButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    
    var scene: TutorialScene!
    let level = 0
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        scene = TutorialScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.tapThreeHandler = handleTapThree
        scene.grid = Grid(level: level, layer: scene.picturesLayer)
        skView.presentScene(scene)
        
        beginGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginGame() {
        
        scene.grid.selectInitialPictures()
        
        let pictures = scene.grid.pictures
        scene.addSpritesForPictures(pictures)
        hintLabel.alpha = 0.0
        
    }
    
    // Called when user taps three PicSprites
    func handleTapThree(group: PictureGroup) {
        view.userInteractionEnabled = false
        
        println("Selected: \(group.description)")
        
        if group.isValidGroup() {
            println("valid group")
            scene.animateValidGroupTutorial(group) {
                
                let defaults = NSUserDefaults.standardUserDefaults()
                if defaults.arrayForKey("highScores") == nil {
                    let highScoresArray = [10]
                    defaults.setObject(highScoresArray, forKey: "highScores")
                }
                
                self.performSegueWithIdentifier("fadeSegue", sender: self)
            }
        } else {
            println("invalid group")
            group.pictureA.wiggleAndDeselect()
            group.pictureB.wiggleAndDeselect()
            group.pictureC.wiggleAndDeselect()
            scene.selectedPics.removeAll()
            view.userInteractionEnabled = true
        }
    }
    
    @IBAction func hintButtonTapped(sender: AnyObject) {
        
        UIView.animateWithDuration(1.0, animations: {
            println("Hint button tapped")
            self.needHintButton.alpha = 0.0
            },
            completion: { finished in
                self.needHintButton.removeFromSuperview()
                UIView.animateWithDuration(1.0, animations: {
                    self.hintLabel.alpha = 1.0
                })
        })
    }
    
    // Present alert after user has found 2 valid groups
    func presentEndOfTutorialAlert() {
        let alertController = UIAlertController(title: "You found both (mis)matches", message: "You're ready to play!", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            println("OK pressed")
            self.performSegueWithIdentifier("unwindToHomeTutorial", sender: self)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            println("presenting alert controller")
        }
    }
}