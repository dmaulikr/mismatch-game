//
//  FadeSegue.swift
//  Find3
//
//  Created by Susan Stevens on 6/19/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import UIKit
import QuartzCore

class FadeSegue: UIStoryboardSegue {
   
    override func perform() {

        let source = sourceViewController as! UIViewController
        let destination = destinationViewController as! UIViewController
        let window = UIApplication.sharedApplication().keyWindow!
        
        destination.view.alpha = 0.0
        window.insertSubview(destination.view, belowSubview: source.view)
        
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            source.view.alpha = 0.0
            destination.view.alpha = 1.0
        }) { (finished) -> Void in
            source.view.alpha = 1.0
            source.presentViewController(destination, animated: false, completion: nil)
        }
    }
}
