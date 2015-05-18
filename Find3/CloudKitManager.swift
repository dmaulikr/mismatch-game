//
//  CloudKitManager.swift
//  Find3
//
//  Created by Susan Stevens on 5/16/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    static let sharedInstance = CloudKitManager()
    
    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase
    
    init() {
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    func addHighScore(highScore: HighScore) {
        let record = CKRecord(recordType: "HighScores")
        record.setValue(highScore.score, forKey: "Score")
        record.setValue(highScore.date, forKey: "DateTime")
        publicDB.saveRecord(record, completionHandler: { (record, error) in
            if error != nil {
                println("There was an error: \(error)")
            } else {
                println("Record saved successfully")
            }
        })
    }
    
    func retrieveHighScores(completion: (results: [HighScore]?, error: NSError?) -> Void) {
        println("Retrieving high scores from iCloud")
        
        var results = [HighScore]()
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "HighScores", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "Score", ascending: false)]
        var queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 5
        
        queryOperation.recordFetchedBlock = { record in
            if let date = record.objectForKey("DateTime") as? NSDate {
                if let score = record.objectForKey("Score") as? Int {
                    let highscore = HighScore(score: score, date: date)
                    results += [highscore]
                }
            }
        }
        
        queryOperation.queryCompletionBlock = { (cursor: CKQueryCursor!, error: NSError!) in
            if error != nil {
                println("Error retrieving from iCloud: \(error)")
                completion(results: nil, error: error)
            } else {
                completion(results: results, error: nil)
            }
        }
        
        publicDB.addOperation(queryOperation)
        
    }
}