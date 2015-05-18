//
//  GameScene.swift
//  Find3
//
//  Created by Susan Stevens on 5/11/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    let TileWidth: CGFloat = 100.0
    let TileHeight: CGFloat = 100.0
    
    let gameLayer = SKNode()
    let picturesLayer = SKNode()
    let grid = Grid()
    
    var tapThreeHandler: ((PictureGroup) -> ())?
    var selectedPics = [Picture]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        backgroundColor = SKColor.whiteColor()
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint(x: -TileWidth * CGFloat(NumColumns) / 2, y: -TileHeight * CGFloat(NumRows) / 2)
        
        picturesLayer.position = layerPosition
        gameLayer.addChild(picturesLayer)
    }
    
    func addSpritesForPictures(pictures: Array2D<Picture>) {
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let picture = pictures[column, row] {
                    let position = pointForColumn(column, row: row)
                    let sprite = PictureSprite(position: position, imageName: picture.imageName)
                    picturesLayer.addChild(sprite)
                    picture.sprite = sprite
                }
            }
        }
    }
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(x: CGFloat(column)*TileWidth + TileWidth/2, y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    
    func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(NumColumns) * TileWidth &&
            point.y >= 0 && point.y < CGFloat(NumRows) * TileHeight {
                return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        } else {
            return (false, 0, 0) // invalid location
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(picturesLayer)
        let (success, column, row) = convertPoint(location)
        
        if success {
            if let picture = grid.pictureAtColumn(column, row: row) {
                println(picture.imageName)
                
                if let sprite = picture.sprite {
                    if sprite.selected {
                        
                        sprite.deselectSprite()
                        
                        if let index = find(selectedPics, picture) {
                            selectedPics.removeAtIndex(index)
                        }
                        
                    } else {
                        
                        sprite.selectSprite()
                        
                        selectedPics += [picture]
                        
                        if selectedPics.count == 3 {
                            if let handler = tapThreeHandler {
                                let group = PictureGroup(pictureA: selectedPics[0], pictureB: selectedPics[1], pictureC: selectedPics[2])
                                handler(group)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func replaceThree(group: PictureGroup, completion: () -> ()) {
        println("replaceThree!")
    }
    
    func animateValidGroup(group: PictureGroup, completion: () -> ()) {
        group.pictureA.sprite!.removeWithActions()
        group.pictureB.sprite!.removeWithActions()
        group.pictureC.sprite!.removeWithActions()
        runAction(SKAction.waitForDuration(0.3), completion: completion)
        selectedPics.removeAll()
    }
    
    func animateFallingPictures(columns: [[Picture]], completion: () -> ()) {
        var longestDuration: NSTimeInterval = 0
        for array in columns {
            for (idx, picture) in enumerate(array) {
                let newPosition = pointForColumn(picture.column!, row: picture.row!)
                let delay = 0.05 + 0.15 * NSTimeInterval(idx)
                
                let sprite = picture.sprite!
                let duration = NSTimeInterval(((sprite.position.y - newPosition.y) / TileHeight) * 0.1)
                longestDuration = max(longestDuration, duration + delay)
                
                let moveAction = SKAction.moveTo(newPosition, duration: duration)
                moveAction.timingMode = .EaseOut
                sprite.runAction(SKAction.sequence([SKAction.waitForDuration(delay), moveAction]))
                
            }
        }
        runAction(SKAction.waitForDuration(longestDuration), completion: completion)
    }
    
    func animateNewPictures(columns: [[Picture]], completion: () -> ()) {
        var longestDuration: NSTimeInterval = 0
        
        for array in columns {
            let startRow = array[0].row! + 1
            for (idx, picture) in enumerate(array) {
                let position = pointForColumn(picture.column!, row: startRow)
                let sprite = PictureSprite(position: position, imageName: picture.imageName)
                picturesLayer.addChild(sprite)
                picture.sprite = sprite
                
                let delay = 0.1 + 0.2 * NSTimeInterval(array.count - idx - 1)
                let duration = NSTimeInterval(startRow - picture.row!) * 0.1
                longestDuration = max(longestDuration, duration + delay)
                
                let newPosition = pointForColumn(picture.column!, row: picture.row!)
                let moveAction = SKAction.moveTo(newPosition, duration: duration)
                moveAction.timingMode = .EaseOut
                sprite.alpha = 0
                sprite.runAction(
                    SKAction.sequence([
                        SKAction.waitForDuration(delay),
                        SKAction.group([
                            SKAction.fadeInWithDuration(0.05), moveAction])
                    ]))
            }
        }
        runAction(SKAction.waitForDuration(longestDuration), completion: completion)
    }
    
}