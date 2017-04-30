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
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        scene = TutorialScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.tapThreeHandler = handleTapThree
        scene.grid = Grid(level: level, layer: scene.picturesLayer)
        skView.presentScene(scene)
        
        beginGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Set up sprites and hint label
    func beginGame() {
        
        scene.grid.selectInitialPictures(level)
        
        let pictures = scene.grid.pictures
        scene.addSpritesToScene(pictures)
        hintLabel.alpha = 0.0
        
    }
    
    /// Called when user taps three PicSprites
    func handleTapThree(_ group: PictureGroup) {
        view.isUserInteractionEnabled = false
        
        print("Selected: \(group.description)")
        
        if group.isValid() {
            print(" - Valid group - ")
            scene.animateValidGroup(group) {
                
                let defaults = UserDefaults.standard
                
                if defaults.array(forKey: "highScores") == nil {
                    let highScoresArray = [10]
                    defaults.set(highScoresArray, forKey: "highScores")
                }
                
                self.performSegue(withIdentifier: "fadeSegue", sender: self)
            }
        } else {
            
            print(" - Invalid group - ")
            
            group.pictureA.runInvalidGroupAction()
            group.pictureB.runInvalidGroupAction()
            group.pictureC.runInvalidGroupAction()
            
            scene.selectedPics.removeAll()
            view.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func hintButtonTapped(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 1.0, animations: {
            
            print("Hint button tapped")
            self.needHintButton.alpha = 0.0
            
            },
            
            completion: { finished in
                self.needHintButton.removeFromSuperview()
                UIView.animate(withDuration: 0.8, animations: {
                    self.hintLabel.alpha = 1.0
                })
        })
    }
}
