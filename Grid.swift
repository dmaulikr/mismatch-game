//
//  Grid.swift
//  Find3
//
//  Created by Susan Stevens on 5/13/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import Foundation
import SpriteKit

let NumColumns = 3
let NumRows = 3

class Grid {
    
    private var allPictures: Array<PicSprite>
    var pictures = Array2D<PicSprite>(columns: NumColumns, rows: NumRows)
    
    var index = 0
    
    init(level: Int, layer: SKNode) {
        switch level {
        case -1:
            allPictures = PicSprite.createExamplePics()
        case 0:
            allPictures = PicSprite.createTutorialPics()
        default:
            allPictures = PicSprite.createAll(level)
        }
    }

// MARK: - Set-up initial grid
    
    func setLevel(level: Int) {
        
        for picSprite in allPictures {
            
            if level == 8 || level == 9 || level == 10 {
                picSprite.imageName = "level\(level)" + "-" + "\(picSprite.imageNum % 9)"
                picSprite.addAnimations(level)
            } else {
                picSprite.imageName = "level\(level)" + "-" + "\(picSprite.imageNum)"
                picSprite.action = nil
                picSprite.removeAllActions()
            }
            
            picSprite.zRotation = 0.0
            picSprite.deselectSprite()
            
        }
    }
    
    func selectInitialPictures(level: Int) {
        
        allPictures.shuffle()
        
        do {
            clearOnscreenPictures()
            for row in 0..<NumRows {
                for column in 0..<NumColumns {
                    
                    while allPictures[index].parent != nil || allPictures[index].onscreen {
                        index++
                        if index == allPictures.count {
                            allPictures.shuffle()
                            index = 0
                        }
                    }

                    let picture = allPictures[index]
                    picture.column = column
                    picture.row = row
                    picture.onscreen = true
                    pictures[column, row] = picture
                }
            }
        } while !containsValidGroup()
    }
    
    func setupExamplePictures(page: Int) {
        
        index = 0
        
        // Add each PicSprite to the grid
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                
                let picture = allPictures[index]
                
                picture.column = column
                picture.row = row
                picture.onscreen = true
                picture.deselectSprite()
                
                pictures[column, row] = picture
                
                index++
            }
        }
        
        // Select 3 PicSprites for (mis)match example
        
        if page == 2 {
            pictureAtColumn(0, row: 1)?.selectSprite()
            pictureAtColumn(1, row: 1)?.selectSprite()
            pictureAtColumn(1, row: 0)?.selectSprite()
        } else if page == 3 {
            pictureAtColumn(0, row: 0)?.selectSprite()
            pictureAtColumn(1, row: 0)?.selectSprite()
            pictureAtColumn(2, row: 0)?.selectSprite()
        } else if page == 4 {
            pictureAtColumn(0, row: 2)?.selectSprite()
            pictureAtColumn(1, row: 2)?.selectSprite()
            pictureAtColumn(1, row: 0)?.selectSprite()
        } else if page == 5 {
            pictureAtColumn(1, row: 0)?.selectSprite()
            pictureAtColumn(2, row: 0)?.selectSprite()
            pictureAtColumn(2, row: 2)?.selectSprite()
        }
        
    }
    
    // Mark any pictures currently onscreen as being offscreen
    func clearOnscreenPictures() {
        if pictures.columns * pictures.rows == NumColumns * NumRows {
            for row in 0..<NumRows {
                for column in 0..<NumColumns {
                    pictureAtColumn(column, row: row)?.onscreen = false
                }
            }
        }
    }
    
    
    func containsValidGroup() -> Bool {
        let numTiles = NumRows * NumColumns
            
        for indexA in 0..<numTiles {
            for indexB in 1..<numTiles {
                for indexC in 2..<numTiles {
                    
                    if indexA != indexB && indexA != indexC && indexB != indexC {
                        
                        let pictureA = pictureAtColumn(indexA / 3, row: indexA % 3)
                        let pictureB = pictureAtColumn(indexB / 3, row: indexB % 3)
                        let pictureC = pictureAtColumn(indexC / 3, row: indexC % 3)
                        
                        let group = PictureGroup(pictureA: pictureA!, pictureB: pictureB!, pictureC:pictureC!)
                            
                        if group.isValid() {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    // Return the PicSprite at a given place on the grid
    func pictureAtColumn(column: Int, row: Int) -> PicSprite? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return pictures[column, row]
    }

// MARK: - Remove valid group and refill grid
    
    // Remove a PictureGroup from the grid
    func removePictures(group: PictureGroup) {
        pictures[group.pictureA.column!, group.pictureA.row!] = nil
        pictures[group.pictureB.column!, group.pictureB.row!] = nil
        pictures[group.pictureC.column!, group.pictureC.row!] = nil
    }
    
    // Move PicSprites down to fill holes left by valid group that was removed
    func fillHoles() -> [[PicSprite]] {
        var columns = [[PicSprite]]()
        
        for column in 0..<NumColumns {
            var array = [PicSprite]()
            for row in 0..<NumRows {
                if pictureAtColumn(column, row: row) == nil {
                    for lookup in (row + 1)..<NumRows {
                        if let picture = pictureAtColumn(column, row: lookup) {
                            pictures[column, lookup] = nil
                            pictures[column, row] = picture
                            picture.row = row
                            
                            array.append(picture)
                            
                            break
                        }
                    }
                }
            }
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }
    
    // Add PicSprites after valid group found
    func addMorePictures() -> [[PicSprite]] {
        var columns = [[PicSprite]]()
        
        do {
            
            if !columns.isEmpty { clearPicsInColumns(columns) }
            columns.removeAll()
            for column in 0..<NumColumns {
                
                var array = [PicSprite]()
                for (var row = NumRows - 1; row >= 0 && pictures[column, row] == nil; --row) {
                    while allPictures[index].parent != nil || allPictures[index].onscreen {
                        index++
                        if index == allPictures.count {
                            allPictures.shuffle()
                            index = 0
                        }
                    }

                    let picture = allPictures[index]
                    picture.column = column
                    picture.row = row
                    picture.onscreen = true
                    pictures[column, row] = picture
                    array.append(picture)
                    index++
                    if index == allPictures.count {
                        allPictures.shuffle()
                        index = 0
                    }
                }
                if !array.isEmpty {
                    columns.append(array)
                }
            }
        } while !containsValidGroup()
    
        return columns
    }
    
    // Mark given PicSprites (ordered in arrays by column) as NOT onscreen
    func clearPicsInColumns(columns: [[PicSprite]]) {
        for array in columns {
            for picture in array {
                picture.onscreen = false
                pictures[picture.column!, picture.row!] = nil
            }
        }
    }
}