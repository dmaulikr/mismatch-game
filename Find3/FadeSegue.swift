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
        
        let window = UIApplication.shared.keyWindow!
        
        destination.view.alpha = 0.0
        window.insertSubview(destination.view, belowSubview: source.view)
        
        UIView.animate(withDuration: 2.0, animations: { () -> Void in
            self.source.view.alpha = 0.0
            self.destination.view.alpha = 1.0
        }, completion: { (finished) -> Void in
            self.source.view.alpha = 1.0
            self.source.present(self.destination, animated: false, completion: nil)
        }) 
    }
}
