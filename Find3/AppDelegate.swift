//
//  AppDelegate.swift
//  Find3
//
//  Created by Susan Stevens on 5/11/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import UIKit
import AVFoundation
import GameKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var splashScreen: UIView!
    var gameCenterEnabled = Bool()
    var gameCenterDefaultLeaderboard = String()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if ((NSUserDefaults.standardUserDefaults().objectForKey("FirstLaunchDate")) == nil) {
            let date = NSDate()
            NSUserDefaults.standardUserDefaults().setObject(date, forKey: "FirstLaunchDate")
            println("first launch date: \(date)")
        }
        
        splashScreen = NSBundle.mainBundle().loadNibNamed("splashScreen", owner: self, options: nil)[0] as! UIView
        splashScreen.frame = window!.bounds
        
        window!.rootViewController!.view.addSubview(splashScreen)
        println("Splash screen displayed")
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("dismissSplashScreen"), userInfo: nil, repeats: false)
        
        setPreferenceDefaults()
        
        self.authenticateLocalPlayer()
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, error: nil)
        
        return true
    }
    
    // Fade out splash screen
    func dismissSplashScreen() {
        UIView.animateWithDuration(2.0, animations: {
            self.splashScreen.alpha = 0.0
            },
            completion: { finished in
                self.splashScreen.removeFromSuperview()
                println("dismissed splash screen")
        })
    }
    
    // Set developer name in Settings bundle
    func setPreferenceDefaults() {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue("Susan Stevens", forKey: "SettingsCreatedBy")
        defaults.synchronize()
    }
    
    // Authenticate player for Game Center
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = { (viewController, error) -> Void in
            if (viewController != nil) {
                self.window?.rootViewController?.presentViewController(viewController, animated: true, completion: nil)
            } else if (localPlayer.authenticated) {
                self.gameCenterEnabled = true
                
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardID: String!, error: NSError!) -> Void in
                    if error != nil {
                        println(error)
                    } else {
                        self.gameCenterDefaultLeaderboard = leaderboardID
                    }
                })
    
            } else {
                self.gameCenterEnabled = false
                println("Local player could not be authenticated, disabling game center")
                println(error)
            }
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

