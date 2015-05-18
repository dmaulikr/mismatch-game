//
//  Grid.swift
//  Find3
//
//  Created by Susan Stevens on 5/13/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import Foundation

let NumColumns = 3
let NumRows = 3

class Grid {
    var allPictures: Array<Picture>
    var pictures = Array2D<Picture>(columns: NumColumns, rows: NumRows)
    var validGroups = Set<PictureGroup>()
    var index = 0
    
    init() {
        allPictures = Picture.createAllPictures()
        
        do {
            allPictures.shuffle()
            for row in 0..<NumRows {
                for column in 0..<NumColumns {
                    let picture = allPictures[index]
                    picture.column = column
                    picture.row = row
                    pictures[column, row] = picture
                    index++
                }
            }
            detectValidGroups()
        } while validGroups.isEmpty
    }
    
    func detectValidGroups() {
        validGroups.removeAll()
        for indexA in 0..<(NumRows * NumColumns) {
            for indexB in 0..<(NumRows * NumColumns) {
                if indexB != indexA {
                    for indexC in 0..<(NumRows * NumColumns) {
                        if indexA != indexC && indexB != indexC {
                            
                            let pictureA = allPictures[indexA]
                            let pictureB = allPictures[indexB]
                            let pictureC = allPictures[indexC]
                            
                            let group = PictureGroup(pictureA: pictureA, pictureB: pictureB, pictureC: pictureC)
                            if group.isValidGroup() {
                                validGroups.insert(group)
                            }
                            
                        }
                    }
                }
            }
        }
        println("valid groups: \(validGroups.count)")
    }
    
    func pictureAtColumn(column: Int, row: Int) -> Picture? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return pictures[column, row]
    }
    
    func removePictures(group: PictureGroup) {
        pictures[group.pictureA.column!, group.pictureA.row!] = nil
        pictures[group.pictureB.column!, group.pictureB.row!] = nil
        pictures[group.pictureC.column!, group.pictureC.row!] = nil
    }
    
    func fillHoles() -> [[Picture]] {
        var columns = [[Picture]]()
        
        for column in 0..<NumColumns {
            var array = [Picture]()
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
    
    func addMorePictures() -> [[Picture]] {
        var columns = [[Picture]]()
        do {
            columns.removeAll()
            for column in 0..<NumColumns {
                var array = [Picture]()
                for (var row = NumRows - 1; row >= 0 && pictures[column, row] == nil; --row) {
                    if index == allPictures.count {
                        index = 0
                    }
                    let picture = allPictures[index]
                    picture.column = column
                    picture.row = row
                    pictures[column, row] = picture
                    array.append(picture)
                    index++
                }
            if !array.isEmpty {
                columns.append(array)
                }
            }
            detectValidGroups()
        } while validGroups.isEmpty
        return columns
    }
    
}