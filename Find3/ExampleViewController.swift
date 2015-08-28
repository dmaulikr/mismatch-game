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
    var page: Int?
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
    
    /// Add example-page sprites to scene. Display red x on page 5.
    func displaySprites() {
        
        scene.grid.setupExamplePictures(page!)
        let pictures = scene.grid.pictures
        scene.addSpritesToScene(pictures)
        
        // Display red x on page 5
        
        if page == 5 {
            let redXTexture = SKTexture(imageNamed: "red-x")
            let redX = SKSpriteNode(texture: redXTexture)
            
            redX.position = CGPoint(x: (TileHeight * CGFloat(NumRows)) / 2,
                                    y: (TileWidth * CGFloat(NumColumns)) / 2)
            
            scene.picturesLayer.addChild(redX)
        }
        
    }
}
