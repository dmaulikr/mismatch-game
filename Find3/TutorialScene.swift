//
//  TutorialScene.swift
//  Find3
//
//  Created by Susan Stevens on 6/4/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import SpriteKit

class TutorialScene: SKScene {
    
    let TileWidth: CGFloat = 100.0
    let TileHeight: CGFloat = 100.0
    let offsetForInstructions: CGFloat = 30
    
    let gameLayer = SKNode()
    let picturesLayer = SKNode()
    var grid: Grid!
    
    var tapThreeHandler: ((PictureGroup) -> ())?
    var selectedPics = [PicSprite]()
    
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
        picturesLayer.name = "Pictures Layer"
        gameLayer.name = "Game Layer"
        gameLayer.addChild(picturesLayer)
    }
    
    // Put nine sprites on the scene
    func addSpritesForPictures(pictures: Array2D<PicSprite>) {
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let picture = pictures[column, row] {
                    picture.position = pointForColumn(column, row: row)
                    picturesLayer.addChild(picture)
                    println(picture.imageName)
                }
            }
        }
    }
    
    // Perform animation when user selects a valid group
    func animateValidGroupTutorial(group: PictureGroup) {
        
        group.pictureA.expandAndDeselect()
        group.pictureB.expandAndDeselect()
        group.pictureC.expandAndDeselect()
        
        selectedPics.removeAll(keepCapacity: true)
    }
    
    // Return center point for given column and row on grid
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(x: CGFloat(column)*TileWidth + TileWidth/2, y: CGFloat(row)*TileHeight + TileHeight/2 - offsetForInstructions)
    }
    
    // Return column and row for given point
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
                            let group = PictureGroup(pictureA: selectedPics[0], pictureB: selectedPics[1], pictureC: selectedPics[2])
                            handler(group)
                        }
                    }
                }
            }
        }
    }
}
