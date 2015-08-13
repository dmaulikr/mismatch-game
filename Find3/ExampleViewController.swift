//
//  ExampleViewController.swift
//  Find3
//
//  Created by Susan Stevens on 6/19/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import Foundation
import SpriteKit

class ExampleViewController: UIViewController {

    var scene: TutorialScene!
    let level = -1
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        scene = TutorialScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.grid = Grid(level: level, layer: scene.picturesLayer)
        skView.presentScene(scene)
        
        view.userInteractionEnabled = false
        
        displaySprites()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displaySprites() {
        
        scene.grid.selectInitialPictures()
        
        let pictures = scene.grid.pictures
        scene.addSpritesForPictures(pictures)
    }
}
