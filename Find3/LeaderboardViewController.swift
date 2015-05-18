//
//  LeaderboardViewController.swift
//  Find3
//
//  Created by Susan Stevens on 5/16/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import UIKit
import CloudKit

class LeaderboardViewController: UIViewController, UITableViewDataSource {

    let cellIdentifier = "LeaderboardCell"
    var tableData = [HighScore]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var activityViewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        getHighScores()
    }
    
    func getHighScores() {
        
        tableData.removeAll(keepCapacity: true)
        
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        activityViewLabel.hidden = false
        
        CloudKitManager.sharedInstance.retrieveHighScores {
            results, error in
        
            self.activityView.stopAnimating()
            self.activityViewLabel.hidden = true
            
            if error != nil {
                println("CloudKit error!")
                self.showErrorAlert()
            } else {
                if let data = results {
                    for result in data {
                        self.tableData += [result]
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func showErrorAlert() {
        let alertController = UIAlertController(title: "Uh oh!", message: "Make sure you're signed into iCloud or try again when you have a better network connection.", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.performSegueWithIdentifier("unwindHomeFromLeaderboard", sender: self)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            println("presenting alert controller")
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let cellData = tableData[indexPath.row]
        
        if let label = cell.viewWithTag(200) as? UILabel {
            label.text = "Score: \(cellData.score)"
        }
        
        if let label = cell.viewWithTag(300) as? UILabel {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy 'at' h:mm a"
            label.text = dateFormatter.stringFromDate(cellData.date)
        }
        
        return cell
    }
}
