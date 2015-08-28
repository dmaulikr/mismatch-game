//
//  GameScene.swift
//  Find3
//
//  Created by Susan Stevens on 5/11/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import SpriteKit
import AVFoundation

let TileWidth: CGFloat = 100.0
let TileHeight: CGFloat = 100.0


/// Subclass of SKScene used to animate sprites and handle touches
class GameScene: SKScene {
    
    let gameLayer = SKNode()
    let picturesLayer = SKNode()
    
    var grid: Grid!
    
    var tapThreeHandler: ((PictureGroup) -> ())?
    var selectedPics = [PicSprite]()
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = SKColor.whiteColor()
        
        let layerPosition = CGPoint(x: -TileWidth * CGFloat(NumColumns) / 2, y: -TileHeight * CGFloat(NumRows) / 2)
        picturesLayer.position = layerPosition
        
        addChild(gameLayer)
        gameLayer.addChild(picturesLayer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
// MARK: - Add and remove sprites at start/end of game
    
    /// Add the nine starting sprites
    func addSpritesToScene(pictures: Array2D<PicSprite>) {
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                
                if let picture = pictures[column, row] {
                    picture.position = pointForColumn(column, row: row)
                    picturesLayer.addChild(picture)
                    
                    if let action = picture.action {
                        picture.removeAllActions()
                        picture.runAction(action)
                    }
                }
            }
        }
    }
    
    /// Remove displayed PicSprites from the scene
    func removeSpritesFromScene(pictures: Array2D<PicSprite>) {
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let picture = pictures[column, row] {
                    picture.removeFromParent()
                }
            }
        }
    }
    
// MARK: - Convert between point and column/row on grid

    /// Return the center point for a particular column and row on the grid
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        
        return CGPoint(x: CGFloat(column)*TileWidth + TileWidth/2, y: CGFloat(row)*TileHeight + TileHeight/2)
        
    }
    
    /// Convert a point to a particular column and row on the grid
    func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        
        if point.x >= 0 && point.y >= 0
            && point.x < CGFloat(NumColumns) * TileWidth
            && point.y < CGFloat(NumRows) * TileHeight {
                
                return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
                
        } else {
            
            return (false, 0, 0) // invalid location
            
        }
    }
    
// MARK: - Touch detection
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(picturesLayer)
        let (success, column, row) = convertPoint(location)
        
        if success {
            
            // Play select sound
            
            if Sounds.sharedInstance.selectSound.playing {
                Sounds.sharedInstance.selectSound.stop()
                Sounds.sharedInstance.selectSound.currentTime = 0.0
            }
            Sounds.sharedInstance.selectSound.play()
            
            // Select or deselect the sprite that was touched
            
            if let picture = grid.pictureAtColumn(column, row: row) {
                
                if picture.selected {
                    
                    picture.deselectSprite()
                    if let index = find(selectedPics, picture) {
                        selectedPics.removeAtIndex(index)
                    }
                    
                } else {
                    
                    picture.selectSprite()
                    selectedPics += [picture]
                    
                    if selectedPics.count == 3 {
                        if let handler = tapThreeHandler {
                            
                            let group = PictureGroup(pictureA: selectedPics[0],
                                    pictureB: selectedPics[1],
                                    pictureC: selectedPics[2])
                            
                            handler(group)
                            
                        }
                    }
                }
            }
        }
    }
    
// MARK: - Add and remove sprites upon valid group selection
    
    /// Perform animation and remove valid group selected by user
    func animateValidGroup(group: PictureGroup, completion: () -> ()) {
        
        group.pictureA.runValidGroupAction()
        group.pictureB.runValidGroupAction()
        group.pictureC.runValidGroupAction()
        
        runAction(SKAction.waitForDuration(0.6), completion: completion)
        
        group.pictureA.onscreen = false
        group.pictureB.onscreen = false
        group.pictureC.onscreen = false
        
        group.pictureA.selected = false
        group.pictureB.selected = false
        group.pictureC.selected = false
        
        selectedPics.removeAll(keepCapacity: true)
    }
    
    /// Animate sprites falling down after a valid group has been selected
    func animateFallingPictures(columns: [[PicSprite]], completion: () -> ()) {
        
        var longestDuration: NSTimeInterval = 0
        
        for array in columns {
            for (idx, picture) in enumerate(array) {
                
                let newPosition = pointForColumn(picture.column!, row: picture.row!)
                
                let delay = 0.05 + 0.15 * NSTimeInterval(idx)
                let duration = NSTimeInterval(((picture.position.y - newPosition.y) / TileHeight) * 0.1)
                
                longestDuration = max(longestDuration, duration + delay)
                
                let moveAction = SKAction.moveTo(newPosition, duration: duration)
                moveAction.timingMode = .EaseOut
                picture.runAction(SKAction.sequence([SKAction.waitForDuration(delay), moveAction]))
                
            }
        }
        runAction(SKAction.waitForDuration(longestDuration), completion: completion)
    }
    
    /// Animate new sprites falling into place after valid group selected
    func animateNewPictures(columns: [[PicSprite]], completion: () -> ()) {
        
        var longestDuration: NSTimeInterval = 0
        
        for array in columns {
            
            let startRow = array[0].row! + 1
            
            for (idx, picture) in enumerate(array) {
                
                picture.position = pointForColumn(picture.column!, row: startRow)
                picturesLayer.addChild(picture)
                
                let newPosition = pointForColumn(picture.column!, row: picture.row!)
                
                let delay = 0.1 + 0.2 * NSTimeInterval(array.count - idx - 1)
                let duration = NSTimeInterval(startRow - picture.row!) * 0.1
                longestDuration = max(longestDuration, duration + delay)
                

                let moveAction = SKAction.moveTo(newPosition, duration: duration)
                moveAction.timingMode = .EaseOut
                picture.alpha = 0
                picture.runAction(
                    SKAction.sequence([
                        SKAction.waitForDuration(delay),
                        SKAction.group([SKAction.fadeInWithDuration(0.05), moveAction]),
                    ]))
                
                
                if let action = picture.action {
                    picture.runAction(action)
                }
            }
        }
        runAction(SKAction.waitForDuration(longestDuration), completion: completion)
    }
    
}