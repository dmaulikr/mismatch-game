//
//  Sounds.swift
//  Find3
//
//  Created by Susan Stevens on 6/26/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import Foundation
import AVFoundation

class Sounds {
    var backgroundMusic = AVAudioPlayer()
    var selectSound = AVAudioPlayer()
    var dropSound = AVAudioPlayer()
    var validGroupSound = AVAudioPlayer()
    var invalidGroupSound = AVAudioPlayer()
    
    static let sharedInstance = Sounds()
    
    private init() {
        backgroundMusic = setupAudioPlayer("Main Title - reg", type: "mp3")
        selectSound = setupAudioPlayer("Tap - select", type: "wav")
        dropSound = setupAudioPlayer("Drop 3", type: "wav")
        validGroupSound = setupAudioPlayer("Drop 3", type: "wav")
        invalidGroupSound = setupAudioPlayer("Wrong", type: "wav")
        
        backgroundMusic.volume = 0.2
    }
    
    func setupAudioPlayer(file: String, type: String) -> AVAudioPlayer {
        var path = NSBundle.mainBundle().pathForResource(file, ofType: type)
        var url = NSURL.fileURLWithPath(path!)
        
        var error: NSError?
        
        var audioPlayer: AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        
        return audioPlayer!
    }
    
}
