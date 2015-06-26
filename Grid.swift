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

// Grid class determines which PicSprites (images) will be placed onscreen and how to lay them out

class Grid {
    var allPictures: Array<PicSprite>
    var pictures = Array2D<PicSprite>(columns: NumColumns, rows: NumRows)
    var validGroups = Set<PictureGroup>()
    
    var index = 0
    
    init(level: Int, layer: SKNode) {
        
        if level == -1 {
            allPictures = PicSprite.createExamplePics()
        } else if level == 0 {
            allPictures = PicSprite.createTutorialPics()
        } else {
            allPictures = PicSprite.createAll(level)
            allPictures.shuffle()
        }
        
        do {
            clearOnscreenPictures()
            for row in 0..<NumRows {
                for column in 0..<NumColumns {
                    let picture = allPictures[index]
                    picture.column = column
                    picture.row = row
                    picture.onscreen = true
                    pictures[column, row] = picture
                    index++
                    if index == allPictures.count {
                        allPictures.shuffle()
                        index = 0
                    }
                }
            }
            detectValidGroups()
        } while validGroups.isEmpty
    }
    
    // Mark any pictures currently onscreen as being offscreen
    func clearOnscreenPictures() {
        if pictures.columns * pictures.rows == NumColumns * NumRows {
            for row in 0..<NumRows {
                for column in 0..<NumColumns {
                    pictures[column, row]?.onscreen = false
                }
            }
        }
    }
    
    // Determine how many valid groups are onscreen
    func detectValidGroups() {
        println("detectValidGroups start")
        validGroups.removeAll()
        for indexA in 0..<(NumRows * NumColumns) {
            for indexB in 0..<(NumRows * NumColumns) {
                if indexB != indexA {
                    for indexC in 0..<(NumRows * NumColumns) {
                        if indexA != indexC && indexB != indexC {
                            
                            let pictureA = pictureAtColumn(indexA / 3, row: indexA % 3)
                            let pictureB = pictureAtColumn(indexB / 3, row: indexB % 3)
                            let pictureC = pictureAtColumn(indexC / 3, row: indexC % 3)
                            
                            if let picA = pictureA {
                                if let picB = pictureB {
                                    if let picC = pictureC {
                                        let group = PictureGroup(pictureA: picA, pictureB: picB, pictureC: picC)
                                        
                                        if group.isValidGroup() {
                                            validGroups.insert(group)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        println("valid groups: \(validGroups.count)")
    }
    
    // Return the PicSprite at a given place on the grid
    func pictureAtColumn(column: Int, row: Int) -> PicSprite? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return pictures[column, row]
    }
    
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
                if pictures[column, row] == nil {
                    for lookup in (row + 1)..<NumRows {
                        if let picture = pictures[column, lookup] {
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
        
        for column in 0..<NumColumns {
            for row in 0..<NumRows {
                if pictures[column, row] == nil {
                    println("empty square: (\(column), \(row))")
                }
            }
        }
        
        do {
            println("Attempting to add more PicSprites")
            if !columns.isEmpty { clearPicsInColumns(columns) }
            columns.removeAll()
            for column in 0..<NumColumns {
                
                println("addMorePictures: in outer for loop")
                
                var array = [PicSprite]()
                for (var row = NumRows - 1; row >= 0 && pictures[column, row] == nil; --row) {
                    println("addMorePictures: in inner for loop")
                    while allPictures[index].parent != nil || allPictures[index].onscreen {
                        index++
                        println("addMorePictures: in while loop")
                        if index == allPictures.count {
                            allPictures.shuffle()
                            index = 0
                        }
                    }

                    println("TO ADD: index: \(index), sprite: \(allPictures[index].imageName)")
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
                    println("append array")
                    columns.append(array)
                }
            }
            detectValidGroups()
        } while validGroups.isEmpty
    
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